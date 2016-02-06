from collections import namedtuple
import os
import binascii

IMMUTABLE_OBJECT_FIELDS = ['oauth_authorization_uri', 'oauth_token_uri', 'oauth_token_refresh_uri', 'api_uri',
                           'redirect_uri', 'response_type', 'state', 'client_id', 'client_secret', 'scope',
                           'grant_type', 'grant_type_refresh_token']


class AuthenticationParameters(namedtuple('AuthenticationParameters', IMMUTABLE_OBJECT_FIELDS)):
    __slots__ = ()

    DEFAULT_AUTH_URI = "https://sequencing.com/oauth2/authorize"
    DEFAULT_TOKEN_URI = "https://sequencing.com/oauth2/token"
    DEFAULT_TOKEN_REFRESH_URI = "https://sequencing.com/oauth2/token?q=oauth2/token"
    DEFAULT_API_URI = "https://api.sequencing.com"
    DEFAULT_RESPONSE_TYPE = "code"
    DEFAULT_SCOPE = "demo"
    DEFAULT_GRANT_TYPE = "authorization_code"
    DEFAULT_GRANT_TYPE_REFRESH = "refresh_token"

    @staticmethod
    def next_state():
        return binascii.hexlify(os.urandom(32))

    class ConfigurationBuilder(object):

        def __init__(self):
            self.oauth_authorization_uri = AuthenticationParameters.DEFAULT_AUTH_URI
            self.oauth_token_uri = AuthenticationParameters.DEFAULT_TOKEN_URI
            self.oauth_token_refresh_uri = AuthenticationParameters.DEFAULT_TOKEN_REFRESH_URI
            self.api_uri = AuthenticationParameters.DEFAULT_API_URI
            self.response_type = AuthenticationParameters.DEFAULT_RESPONSE_TYPE
            self.scope = AuthenticationParameters.DEFAULT_SCOPE
            self.grant_type = AuthenticationParameters.DEFAULT_GRANT_TYPE
            self.grant_type_refresh_token = AuthenticationParameters.DEFAULT_GRANT_TYPE_REFRESH
            self.state = AuthenticationParameters.next_state()

        def with_oauth_authorization_uri(self, oauth_authorization_uri):
            self.oauth_authorization_uri = oauth_authorization_uri
            return self

        def with_oauth_token_uri(self, oauth_token_uri):
            self.oauth_token_uri = oauth_token_uri
            return self

        def with_oauth_token_refresh_uri(self, oauth_token_refresh_uri):
            self.oauth_token_refresh_uri = oauth_token_refresh_uri
            return self

        def with_api_uri(self, api_uri):
            self.api_uri = api_uri
            return self

        def with_redirect_uri(self, redirect_uri):
            self.redirect_uri = redirect_uri
            return self

        def with_response_type(self, response_type):
            self.response_type = response_type
            return self

        def with_state(self, state):
            self.state = state
            return self

        def with_client_id(self, client_id):
            self.client_id = client_id
            return self

        def with_client_secret(self, client_secret):
            self.client_secret = client_secret
            return self

        def with_scope(self, scope):
            self.scope = scope
            return self

        def with_grant_type(self, grant_type):
            self.grant_type = grant_type
            return self

        def with_grant_type_refresh_token(self, grant_type_refresh_token):
            self.grant_type_refresh_token = grant_type_refresh_token
            return self

        def build(self):
            return AuthenticationParameters(self.oauth_authorization_uri, self.oauth_token_uri, self.oauth_token_refresh_uri,
                                            self.api_uri, self.redirect_uri, self.response_type, self.state,
                                            self.client_id, self.client_secret, self.scope, self.grant_type,
                                            self.grant_type_refresh_token)
