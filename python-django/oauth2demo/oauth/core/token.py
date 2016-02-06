class Token(object):
    def __init__(self, access_token, refresh_token, lifetime):
        self.access_token = access_token # Access token value
        self.refresh_token = refresh_token # Token needed for refreshing access token
        self.lifetime = lifetime # Access token lifetime
