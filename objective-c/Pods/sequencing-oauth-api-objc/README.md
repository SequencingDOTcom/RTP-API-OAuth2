# CocoaPods plugin for quickly adding Sequencing.com's OAuth2 and File Selector to iOS apps coded in Objective-C

=========================================
This repo contains CocoaPods plugin code for implementing Sequencing.com's OAuth2 authentication and File Selector for your app so that your app can securely access [Sequencing.com's](https://sequencing.com/) API and app chains.

This CocoaPods plugin can be found here: http://cocoapods.org/pods/sequencing-oauth-api-objc

Want to see it in action? A demo of the OAuth2 code is available here: https://oauth-demo.sequencing.com/

The code for this plugin is also available in the following languages: 

* [Objective-C (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPods-Objective-C-iOS-plugin) <- this repo
* [Objective-C (code)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/objective-c)
* [Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPods-Swift-iOS-plugin)
* [Swift (code)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/swift)
* [Android (Maven plugin)](https://github.com/SequencingDOTcom/Maven-Android-plugin)
* [Android (code)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/android)
* [PHP](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/php)
* [Perl](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/perl)
* [Python (Django)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/python-django)
* [Java (Servlet)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/java-servlet)
* [Java (Spring)](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/java-spring)
* [.NET/C#](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/tree/master/dot-net-cs)

Contents
=========================================
* Introduction
* Implementation
* App chains
* Authentication flow
* Steps
* Resources
* Maintainers
* Contribute

Introduction
=========================================
The code in this repo can be used to quickly implement OAuth2 authentication for Sequencing.com's API. By adding OAuth2 authentication to your app, you'll then be able to use Sequencing.com's API to ehance your app with Real-Time Personalization.

The code has also been deployed and can be accessed online as an [OAuth2 demo](https://oauth-demo.sequencing.com/).
* A end-user validates using thier Sequencing.com login and, if successfull, the demo will provide a list of genetic data files from the user's account at Sequencing.com.
* The demo will display a list of sample files if a user doesn't yet have access to his or her genetic data. These sample files are real genetic data files and are available for free for apps that use Sequencing.com's API.

To code Real-Time Personalization technology into apps, developers may [register for a free account](https://sequencing.com/user/register/) at Sequencing.com. App development with RTP is always free.

Implementation
======================================
To implement OAuth2 authentication for your app:

1) [Register](https://sequencing.com/user/register/) for a free account

3) [Generate an OAuth2 secret](https://sequencing.com/api-secret-generator) for your app

2) Add [this plugin](http://cocoapods.org/pods/sequencing-oauth-api-objc) to your iOS app coded in Objective-C and insert the OAuth2 secret

Once you've popped this plugin into your app, add one or more App Chains. Each app chain will provide your app with actionable information obtained from the app user's genes. Your app will be able to use this unique informamtion to provide a highly personalized UX for each user.

App Chains
======================================
Search and find app chains -> https://sequencing.com/app-chains/

While there are already app chains to personalize most apps, if you need something but don't see an app chain for it, tell us! (ie email us: gittaca@sequencing.com).

Each app chain is composed of 
* an **API request** to Sequencing.com
 * this request is secured using OAuth2
* analysis of the app user's genes
 * each app chain analyzes a specific trait or condition
 * there are thousands of app chains to choose from
 * all analysis occurs in real-time at Sequencing.com
* an **API response** to your app
 * the information provided by the response allows your app to tailor itself to the app user based on the user's genes.
 * the documentation for each app chain provides a list of all possible API responses. The response for most app chains are simply 'Yes' or 'No'.

Example
* App Chain: It is very important for this person's health to apply sunscreen with SPF +30 whenever it is sunny or even partly sunny.
* Possible responses: Yes, No, Insufficient Data, Error


Authentication flow
======================================

Sequencing.com uses standard OAuth approach which enables applications to obtain limited access to user accounts on an HTTP service from 3rd party applications without exposing the user's password. OAuth acts as an intermediary on behalf of the end user, providing the service with an access token that authorizes specific account information to be shared.

![Authentication sequence diagram]
(https://github.com/SequencingDOTcom/oAuth2-code-and-demo/blob/master/screenshots/oauth_activity.png)


## Steps

### Step 1: Authorization Code Link

First, the user is given an authorization code link that looks like the following:

```
https://sequencing.com/oauth2/authorize?redirect_uri=REDIRECT_URL&response_type=code&state=STATE&client_id=CLIENT_ID&scope=SCOPES
```

Here is an explanation of the link components:

* https://sequencing.com/oauth2/authorize: the API authorization endpoint
* client_id=CLIENT_ID: the application's client ID (how the API identifies the application)
* redirect_uri=REDIRECT_URL: where the service redirects the user-agent after an authorization code is granted
* response_type=code: specifies that your application is requesting an authorization code grant
* scope=CODES: specifies the level of access that the application is requesting

![login dialog](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/blob/master/screenshots/oauth_auth.png)

### Step 2: User Authorizes Application

When the user clicks the link, they must first log in to the service, to authenticate their identity (unless they are already logged in). Then they will be prompted by the service to authorize or deny the application access to their account. Here is an example authorize application prompt

![grant dialog](https://github.com/SequencingDOTcom/oAuth2-code-and-demo/blob/master/screenshots/oauth_grant.png)

### Step 3: Application Receives Authorization Code

If the user clicks "Authorize Application", the service redirects the user-agent to the application redirect URI, which was specified during the client registration, along with an authorization code. The redirect would look something like this (assuming the application is "php-oauth-demo.sequencing.com"):

```
https://php-oauth-demo.sequencing.com/index.php?code=AUTHORIZATION_CODE
```

### Step 4: Application Requests Access Token

The application requests an access token from the API, by passing the authorization code along with authentication details, including the client secret, to the API token endpoint. Here is an example POST request to Sequencing.com token endpoint:

```
https://sequencing.com/oauth2/token
```

Following POST parameters have to be sent

* grant_type='authorization_code'
* code=AUTHORIZATION_CODE (where AUTHORIZATION_CODE is a code acquired in a "code" parameter in the result of redirect from sequencing.com)
* redirect_uri=REDIRECT_URL (where REDIRECT_URL is the same URL as the one used in step 1)

### Step 5: Application Receives Access Token

If the authorization is valid, the API will send a JSON response containing the access token to the application.

Resources
======================================
* [App chains](https://sequencing.com/app-chains)
* [File selector code](https://github.com/SequencingDOTcom/File-Selector-code)
* [Developer center](https://sequencing.com/developer-center)
* [Developer documentation](https://sequencing.com/developer-documentation/)

Maintainers
======================================
This repo is actively maintained by [Sequencing.com](https://sequencing.com/). Email the Sequencing.com bioinformatics team at gittaca@sequencing.com if you require any more information or just to say hola.

Contribute
======================================
We encourage you to passionately fork us. If interested in updating the master branch, please send us a pull request. If the changes contribute positively, we'll let it ride.
