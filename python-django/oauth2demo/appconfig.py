class AppConfig():

    """
    URI of Sequencing oAuth2 where you can request user to authorize your app.
    """
    oauth2_authorization_uri = 'https://sequencing.com/oauth2/authorize'

    """
    Sequencing API endpoint.
    """
    api_uri = 'https://api.sequencing.com'

    """
    Redirect URI of your oauth2 app, where it expects Sequencing oAuth2 to
    redirect browser.
    """
    redirect_uri = 'https://python-oauth-demo.sequencing.com/Default/Authcallback'

    """
    Id of your oauth2 app (oauth2 client).
    You will be able to get this value from Sequencing website.
    """
    client_id = 'oAuth2 Demo Python'

    """
    Secret of your oauth2 app (oauth2 client).
    You will be able to get this value from Sequencing website.
    Keep this value private.
    """
    client_secret = 'cyqZOLZfVET_EsKv3f1xekpqe8FZDlG2rNwK5JZyMFkRisKpNC1s-IlM3hj6KlE4e2SsYRDM903Mj2T699fBCw'

    """
    Supply here 'code', which means you want to take 
    the route of authorization code response
    """
    response_type = 'code'

    """
    oAuth2 state.
    It should be some random generated string. State you sent to authorize URI
    must match the state you get, when browser is redirected to the redirect URI
    you provided.
    """
    state = '900150983cd24fb0d6963f7d28e17f72'

    """
    Array of scopes, access to which you request.
    """
    scopes = ['demo']
    
    """
    URI of Sequencing oAuth2 where you can obtain access token.
    """
    oauth2_token_uri = 'https://sequencing.com/oauth2/token'

    """
    Supply here 'authorization_code', which means you request to 
    exchange the authorization code for the aouth2 tokens
    """
    grant_type= 'authorization_code' 
