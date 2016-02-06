from django.shortcuts import render, redirect
from django.core.urlresolvers import reverse
from django.http import HttpResponseRedirect
import urllib

from .appconfig import AppConfig
import oauth

oauth_client = None


# We just being the oauth2 authorization loop. So we redirect the client to
# Sequencing website and ask the user to allow our app to use his data.
def auth(request):
    global oauth_client
    oauth_client = oauth.DefaultSequencingOAuth2Client(__getauth_parameters(AppConfig))

    auth_parameters = oauth_client.auth_parameters
    params = urllib.urlencode({oauth_client.ATTR_REDIRECT_URL: auth_parameters.redirect_uri,
                               oauth_client.ATTR_RESPONSE_TYPE: auth_parameters.response_type,
                               oauth_client.ATTR_STATE: auth_parameters.state,
                               oauth_client.ATTR_CLIENT_ID: auth_parameters.client_id,
                               oauth_client.ATTR_SCOPE: auth_parameters.scope})

    return redirect(auth_parameters.oauth_authorization_uri + '?%s' % params, {})


# We came back from Sequencing website and if state argument matches with our
# state, then we proceed and exchange the authorization code that we are
# given in GET for the access token. The former will be used for
# authorization, when we make requests to Sequencing API.
def auth_callback(request):
    code = request.GET['code']
    state = request.GET['state']

    oauth_client.authorize(code, state)
        
        rurl = reverse('api')
        return HttpResponseRedirect(rurl) 


# We make API requests, using access token.
def api(request):
    file_api = oauth.DefaultSequencingFileMetadataApi(oauth_client)

    return render(request, 'apiResponse.html', {'response_json': file_api.getsample_files()})
    
     
def __getauth_parameters(app_config):
    parameters = oauth.AuthenticationParameters.ConfigurationBuilder()\
                .with_redirect_uri(app_config.redirect_uri)\
                .with_client_id(app_config.client_id)\
                .with_client_secret(app_config.client_secret)\
                .build()
    return parameters
