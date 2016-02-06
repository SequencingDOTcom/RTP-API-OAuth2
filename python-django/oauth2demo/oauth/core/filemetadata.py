from ..exceptions.exceptions import NonAuthorizedException
from ..utils.http import do_oauth_secure_get


# Default implementation of SequencingFileMetadataApi interface
class DefaultSequencingFileMetadataApi(object):
    def __init__(self, oauth_client):
        self._oauth_client = oauth_client

    def getsample_files(self):
        return self.getfiles_by_type("sample")

    def getown_files(self):
        return self.getfiles_by_type("uploaded")

    # Returns files depending on file type
    def getfiles_by_type(self, file_type):
        if self._oauth_client.is_authorized() == False:
            raise NonAuthorizedException()

        uri = '%s/DataSourceList?%s=true&shared=true' % (self._oauth_client.auth_parameters.api_uri, file_type)
        return do_oauth_secure_get(uri, self._oauth_client.token)
