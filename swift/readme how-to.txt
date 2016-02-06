This project contains preinstalled "sequencing-oauth-api-swift" pod via CocoaPods dependency manager.

You need to follow instruction below if you want to install and use OAuth logic and file selector logic in your existed or new project.

1. create a new project in Xcode

2. install pod (see instruction here https://cocoapods.org > getting started)
	
	2.1 create Podfile in your project directory:
		$ pod init
	
	2.2 don't forget to uncomment the row (as this is swift pod) 
		use_frameworks!
		
	2.3 specify "sequencing-oauth-api-swift" pod parameters:
		pod 'sequencing-oauth-api-swift', '~> 1.0.1'
		
	2.4 install the dependency in your project:
		$ pod install
	
	2.5 always open the Xcode workspace instead of the project file:
		$ open *.xcworkspace


3. registrate application parameters
		
	3.1 add pod import (pay attention to substitute original dash characters in title to underscore characters)
		import sequencing_oauth_api_swift

	3.2 for authorization you need to specify your application parameters in String format (BEFORE using authorization methods)
		let CLIENT_ID: String		= "your CLIENT_ID here"
		let CLIENT_SECRET: String	= "your CLIENT_SECRET here"
		let REDIRECT_URI: String    = "REDIRECT_URI here"
		let SCOPE: String           = "SCOPE here"
				
	3.3 parameters registration method is available in "SQOAuth" public class via "instance" init (singleton)
	
	3.3.1 use "registrateApplicationParametersClientID" method
		SQOAuth.instance.registrateApplicationParametersClientID(self.CLIENT_ID, ClientSecret: self.CLIENT_SECRET, RedirectUri: self.REDIRECT_URI, Scope: self.SCOPE)
																	

4. use authorization method(s)

	4.1 authorization methods are available in "SQOAuth" public class via "instance" init (singleton)
	
	4.2 you can authorize your user (e.g. via "login" button)
		for authorization you can use either "authorizeUserWithResult" or "authorizeUserWithTokenResult" method:
		
	4.2.1
		SQOAuth.instance.authorizeUserWithResult { (authResult) -> Void in
            // your code here
        }
		
		"authorizeUserWithResult" will return a closure (block in objc) with "SQAuthResult" shared instance.
		"SQAuthResult" shared instance contains 2 properties:
			var token: SQToken		- it is a always up-to-date token
			var isAuthorized: Bool	- property that sais if user is authorized
			
			Pay attention that you do not need to care about token refresh. It's handled automatically in auth logic.
			There is an internal method that verifies if token is expired and refreshes it.
		
	4.2.2		
		SQOAuth.instance.authorizeUserWithTokenResult { (token) -> Void in
            // your code here
        }
		
		"authorizeUserWithTokenResult" will return a closure (block in objc) with object of SQToken class directly.
		SQToken object contains following 5 properties with clear titles for usage:
			var accessToken:	String
			var expirationDate:	NSDate
			var tokenType:		String
			var scope:			String
			var refreshToken:	String


5. use file selector method(s)
	
	5.1 file selector methods are available in "SQAPI" public class via "instance" init (singleton)
	
	5.2 you can load/get files (list of own files or list of sample files) via "loadOwnFiles" and "loadSampleFiles" methods:
	
	5.2.1
		SQAPI.instance.loadOwnFiles { (files) -> Void in
            // your code here
        }
        
        "loadOwnFiles" will return a closure with NSArray of dictionary objects with file details inside.
    
    5.2.2
    	SQAPI.instance.loadSampleFiles { (files) -> Void in
            // your code here
        }
    	
    	"loadSampleFiles" will return a closure with NSArray of dictionary objects with file details inside.
    
    5.3 each file contains following keys and values:
    	DateAdded:		"string value"
    	Ext:			"string value"
    	FileCategory:	"string value"
    	FileSubType:	"string value"
    	FileType:		"string value"
    	FriendlyDesc1:	"string value"
    	FriendlyDesc2:	"string value"
    	Id:				"string value"
    	Name:			"string value"
    	Population:		"string value"
    	Sex:			"string value"
    
		
		
	

	
	

