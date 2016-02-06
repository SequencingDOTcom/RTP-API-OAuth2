import urllib
import sched
import time
from threading import Thread

from token import Token
from ..utils.http import do_basic_secure_post
from ..exceptions.exceptions import BasicAuthenticationFailedException


class DefaultSequencingOAuth2Client(object):
    # Attribute for value of redirect url 
    ATTR_REDIRECT_URL = "redirect_uri"

    # Attribute for value of response type
    ATTR_RESPONSE_TYPE = "response_type"

    # Attribute for value state
    ATTR_STATE = "state"

    # Attribute for value client id
    ATTR_CLIENT_ID = "client_id"

    # Attribute for value scope
    ATTR_SCOPE = "scope"

    # Attribute for value code
    ATTR_CODE = "code"

    # Attribute for value refresh token
    ATTR_REFRESH_TOKEN = "refresh_token"

    # Attribute for access token
    ATTR_ACCESS_TOKEN = "access_token"

    # Attribute for value grant type
    ATTR_GRANT_TYPE = "grant_type"

    # Attribute for value expires in
    ATTR_EXPIRES_IN = "expires_in"

    def __init__(self, auth_parameters):
        self.auth_parameters = auth_parameters
        self.token = None
        self._token_refresher = None

    def http_redirect_parameters(self):
        attributes = {
            self.ATTR_REDIRECT_URL: self.auth_parameters.redirect_uri,
            self.ATTR_RESPONSE_TYPE: self.auth_parameters.response_type,
            self.ATTR_STATE: self.auth_parameters.state,
            self.ATTR_CLIENT_ID: self.auth_parameters.client_id,
            self.ATTR_SCOPE: self.auth_parameters.scope
        }
        return attributes

    def login_redirect_url(self):
        params = urllib.urlencode(self.http_redirect_parameters())
        return '%s?%s' % (self.auth_parameters.oauth_authorization_uri, params)

    def authorize(self, response_code, response_state):
        if response_state != self.auth_parameters.state:
            raise ValueError("Invalid state parameter")

        uri = self.auth_parameters.oauth_token_uri
        params = {
            self.ATTR_GRANT_TYPE: self.auth_parameters.grant_type,
            self.ATTR_CODE: response_code,
            self.ATTR_REDIRECT_URL: self.auth_parameters.redirect_uri
        }
        result = do_basic_secure_post(uri, self.auth_parameters, params)
        if result is None:
            raise BasicAuthenticationFailedException("Failure authentication.")

        access_token = result[self.ATTR_ACCESS_TOKEN]
        refresh_token = result[self.ATTR_REFRESH_TOKEN]
        timelife = int(result[self.ATTR_EXPIRES_IN])

        self.token = Token(access_token, refresh_token, timelife)

        self._token_refresher = self.__TokenRefresher(self, timelife - 60)
        self._token_refresher.start()

        return self.token

    def is_authorized(self):
        return (self.token is not None) and (self.token.lifetime != 0)

    def _refresh_token(self):
        uri = self.auth_parameters.oauth_token_refresh_uri
        params = {
            self.ATTR_GRANT_TYPE: self.auth_parameters.grant_type_refresh_token,
            self.ATTR_REFRESH_TOKEN: self.token.refresh_token
        }

        result = do_basic_secure_post(uri, self.auth_parameters, params)
        if result is None:
            raise BasicAuthenticationFailedException("Authentication against backend failed. " +
                                                     "Server replied with: " + result)

        access_token = result[self.ATTR_ACCESS_TOKEN]
        refresh_token = self.token.refresh_token
        timelife = result[self.ATTR_EXPIRES_IN]

        self.token = Token(access_token, refresh_token, timelife)

    class __TokenRefresher(Thread):
        def __init__(self, outer, frequency):
            Thread.__init__(self)
            self.outer = outer
            self.frequency = frequency
            self.scheduler = sched.scheduler(time.time, time.sleep)

        def run(self):
            self.scheduler.enter(self.frequency, 1, self.__run_refresh_token, ())
            self.scheduler.run()

        def __run_refresh_token(self):
            self.outer._refresh_token()
            self.scheduler.enter(self.frequency, 1, self.__run_refresh_token, ())
