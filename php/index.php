<?php

/**
 * @file
 * Example of Sequencing API usage for external developers.
 */

/**
 * ID of your oauth2 app (oauth2 client).
 *
 * You will be able to get this value from Sequencing website.
 */
$client_id = 'oAuth2 Demo PHP';

/**
 * Secret of your oauth2 app (oauth2 client).
 *
 * You will be able to get this value from Sequencing website. Keep this value
 * private.
 */
$client_secret = 'at867K7W88Pxrut1kEFZiOXh2Ij36q6dgEDBZyXte-rhYzBqrI_ay609awMD6ZEtGbuPHQnnW9zzncnOpxbdyg';

/**
 * Redirect URI of your oauth2 app, where it expects Sequencing oAuth2 to
 * redirect browser.
 */
$redirect_uri = 'https://php-oauth-demo.sequencing.com/index.php';

/**
 * Array of scopes, access to which you request.
 */
$scopes = array('demo');

/**
 * URI of Sequencing oAuth2 where you can obtain access token.
 */
$oauth2_token_uri = 'https://sequencing.com/oauth2/token';

/**
 * URI of Sequencing oAuth2 where you can request user to authorize your app.
 */
$oauth2_authorization_uri = 'https://sequencing.com/oauth2/authorize';

/**
 * oAuth2 state.
 *
 * It should be some random generated string. State you sent to authorize URI
 * must match the state you get, when browser is redirected to the redirect URI
 * you provided.
 */
$state = md5('abc');

/**
 * Sequencing API endpoint.
 */
$api_uri = 'https://api.sequencing.com';

if (!isset($_GET['code'])) {
  // We just being the oauth2 authorization loop. So we redirect the client to
  // Sequencing website and ask the user to allow our app to use his data.
  header('Location: ' . $oauth2_authorization_uri . '?' . http_build_query(array(
      'redirect_uri' => $redirect_uri,
      'response_type' => 'code',
      'state' => $state,
      'client_id' => $client_id,
      'scope' => implode(' ', $scopes),
    )));
  exit;
}
else {
  // We came back from Sequencing website and if state argument matches with our
  // state, then we proceed and exchange the authorization code that we are
  // given in GET for the access and refresh tokens. The former will be used for
  // authorization, when we make requests to Sequencing API.
  if ($_GET['state'] == $state) {
    $code = $_GET['code'];
    $ch = curl_init();
    curl_setopt_array($ch, array(
      CURLOPT_URL => $oauth2_token_uri,
      CURLOPT_RETURNTRANSFER => TRUE,
      CURLOPT_POST => TRUE,
      CURLOPT_POSTFIELDS => http_build_query(array(
        'grant_type' => 'authorization_code',
        'code' => $code,
        'redirect_uri' => $redirect_uri,
      )),
      CURLOPT_HTTPAUTH => CURLAUTH_BASIC,
      CURLOPT_USERPWD => $client_id . ':' . $client_secret,
    ));
    $response = curl_exec($ch);
    curl_close($ch);
    $response_parsed = json_decode($response);
    if (!$response_parsed || isset($response_parsed->error)) {
      exit('Error in oauth2 token response: ' . $response);
    }
    // You are to save these 2 tokens somewhere in a permanent storage, such as
    // database. When access token expires, you will be able to use refresh
    // token to fetch a new access token without need of re-authorization by
    // user.
    $access_token = $response_parsed->access_token;
    $refresh_token = $response_parsed->refresh_token;

    $ch = curl_init();
    curl_setopt_array($ch, array(
      CURLOPT_URL => $api_uri . '/DataSourceList?sample=true',
      CURLOPT_RETURNTRANSFER => TRUE,
      CURLOPT_HTTPHEADER => array(
        'Authorization: Bearer ' . $access_token,
      ),
    ));
    $response = curl_exec($ch);
    curl_close($ch);
    $response_json = json_decode($response);
    if (!$response_json) {
      exit('Unexpected return from the Sequencing API: ' . $response);
    }

    require 'result.php';
  }
  else {
    exit('State argument mismatch.');
  }
}
