#!/usr/bin/perl
use Digest::MD5 qw(md5 md5_hex md5_base64);
use CGI; 
use JSON;
use HTTP::Request::Common;
use LWP::UserAgent;
use Data::Dumper;
use HTML::Entities;
use CGI::Session;
use warnings;
print qq(Content-type: text/html\n\n);

# @file
# Example of Sequencing API usage for external developers.

# ID of your oauth2 app (oauth2 client).
#
# You will be able to get this value from Sequencing website.
#
my $client_id = 'oAuth2 Demo Perl'; 

# Secret of your oauth2 app (oauth2 client).
#
# You will be able to get this value from Sequencing website. Keep this value
# private.
my $client_secret = 'z7EaaKQGzLGSqXGQ7yOJlcCqynIyYaKCaxahwWuC2YBAhoduP18jWLM5VtkWOWq9-kOhVoWtWmwE5aBjlpcsaA';

# Redirect URI of your oauth2 app, where it expects Sequencing oAuth2 to
# redirect browser.
my $redirect_uri = 'https://perl-oauth-demo.sequencing.com/Default/Authcallback';


# Array of scopes, access to which you request.
my @scopes = ('demo');

# URI of Sequencing oAuth2 where you can obtain access token.
my $oauth2_token_uri = 'https://sequencing.com/oauth2/token';

# URI of Sequencing oAuth2 where you can request user to authorize your app.
my $oauth2_authorization_uri = 'https://sequencing.com/oauth2/authorize';

# oAuth2 state.

# It should be some random generated string. State you sent to authorize URI
# must match the state you get, when browser is redirected to the redirect URI
# you provided.
my $state = md5_hex('abc');

# Sequencing API endpoint.
my $api_uri = 'https://api.sequencing.com';

# Our session
my  $session = new CGI::Session();

#subroutine for geting value by parameter from GET request
sub get_value_of_parameter
{
   if ($ENV{'REQUEST_METHOD'} eq "GET")
   {
	my $parameter = @_[0]; 
	my $buffer = $ENV{'QUERY_STRING'};
	my @pairs = split(/&/, $buffer);
	
	foreach $pair (@pairs)
	{
           ($name, $value) = split(/=/, $pair);
           $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
           $in{$name} = $value; 
	}
	
	return $in{"$parameter"};
   }
   else
   {
	return;
   }
}

# Return access token
sub get_token
{
	  if (!defined $session->param('access_token')) 
	  {
	          my $ua = LWP::UserAgent->new;
        	  $ua->agent("$0/0.1 " . $ua->agent);
	          my $post_req = POST ($oauth2_token_uri,
        	          [
                	          grant_type => 'authorization_code',
                        	  code => @_[0],
	                          redirect_uri => $redirect_uri
        	          ]);
	          $post_req->authorization_basic($client_id, $client_secret);
	          my $response = $ua->request($post_req);
        	  # print $response->decoded_content; 
		  
		  my $json = JSON->new->utf8->allow_nonref;
	          my $response_parsed = $json->decode($response->content());
        	  unless (defined $response_parsed)
	          {
        	       print 'Error in oauth2 token response: ' . $response;
             	       exit;
	          }

       	          # You are to save these 2 tokens somewhere in a permanent storage, such as
        	  # database. When access token expires, you will be able to use refresh
         	  # token to fetch a new access token without need of re-authorization by
          	  # user.
		  
		  my $access_token = $response_parsed->{'access_token'};
	          my $refresh_token = $response_parsed->{'refresh_token'};
	
		  $session->param('last_refresh',  time());		  
		  $session->param('access_token',  $access_token);
		  $session->param('refresh_token', $refresh_token);
		
		  return $access_token;
	  }
 	  # We refresh token every 50 minutes
	  elsif($session->param('last_refresh') + 50*60 < time() )
	  {	
	  	return refresh_token();
	  }

	  else
	  {
		return $session->param('access_token');
	  }
}

# Subroutine for refreshing token
sub refresh_token
{
          my $ua = LWP::UserAgent->new;
          $ua->agent("$0/0.1 " . $ua->agent);
          my $post_req = POST ($oauth2_token_uri,
                  [
                          grant_type => 'refresh_token',
                          refresh_token => $refresh_token
                  ]);
          $post_req->authorization_basic($client_id, $client_secret);
          my $response = $ua->request($post_req);

          my $response_parsed = $json->decode($response->content());
          unless (defined $response_parsed)
          {
               print 'Error in oauth2 token response: ' . $response;
               exit;
          }

          $access_token = $response_parsed->{'access_token'};
	  $session->param('last_refresh',  time());
	  $session->param('access_token',  $access_token);
	
	  return $access_token; 
}

if (!defined get_value_of_parameter('code'))
{
     # We just being the oauth2 authorization loop. So we redirect the client to
     # Sequencing website and ask the user to allow our app to use his data.

     my $joined_scopes = join(' ', @scopes);
     my $url_for_redirect = $oauth2_authorization_uri
	  . "?redirect_uri=$redirect_uri"
	  . "&response_type=code"
	  . "&state=$state"
	  . "&client_id=$client_id"
	  . "&scope=$joined_scopes";
	  
     my $t = 0; # time until redirect activates
     print "<META HTTP-EQUIV=refresh CONTENT=\"$t;URL=$url_for_redirect\">\n";
 }
else
{
     # We came back from Sequencing website and if state argument matches with our
     # state, then we proceed and exchange the authorization code that we are
     # given in GET for the access and refresh tokens. The former will be used for
     # authorization, when we make requests to Sequencing API.

     if(get_value_of_parameter('state') eq $state)
     {
	  my $code = get_value_of_parameter('code');
	  
	  my $access_token = get_token($code);

	  my $browser = LWP::UserAgent->new; 
	  my $second_response = $browser->get($api_uri.'/DataSourceList?sample=true', Authorization => 'Bearer '.$access_token);
	  my $json = JSON->new->utf8->allow_nonref;
	  our @response_json = @{$json->decode($second_response->content())};
	  
	  unless (defined @response_json)
	  {
	       print 'Unexpected return from the Sequencing API: ' . $second_response;
	       exit;
	  }
   
	  require 'result.pl';
     }
     else
     {
	  print 'State argument mismatch.';
	  exit;
     }
}