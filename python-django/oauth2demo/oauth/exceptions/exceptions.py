class BasicAuthenticationFailedException(Exception):
    def __init__(self, message=None, code=None, params=None):
        super(BasicAuthenticationFailedException, self).__init__(message, code, params)

        self.message = message
        self.code = code
        self.params = params
        self.error_list = [self]


class NonAuthorizedException(Exception):
    def __init__(self, message=None, code=None, params=None):
        super(NonAuthorizedException, self).__init__(message, code, params)

        self.message = message
        self.code = code
        self.params = params
        self.error_list = [self]
