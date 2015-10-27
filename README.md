oAuth2 code for Sequencing.com's API and App Chains
=========================================
This repo contains code for implementing [Sequencing.com's](https://sequencing.com/) oAuth2 authentication for your app. 

Want to see it in action? A demo of the oAuth2 code is available here: https://oauth-demo.sequencing.com/

oAuth2 code is available in the following languages:

* Python
* Perl
* .NET/C#
* Java
* Java-Android
* Swift
* Objective-C


Contents
=========================================
* Introduction
* Installation
* Configuration
* Troubleshooting
* Maintainers
* Contribute

Introduction
=========================================
The code in this repo can be used to quickly implement oAuth2 authentication for Sequencing.com's API. By adding oAuth2 authentication to your app, you'll then be able to use Sequencing.com's API to ehance your app with Real-Time Personalization.

The code has also been deployed and can be accessed online as an [oAuth2 demo](https://oauth-demo.sequencing.com/).
* A end-user validates using thier Sequencing.com login and, if successfull, the demo will provide a list of genetic data files from the user's account at Sequencing.com.
* The demo will display a list of sample files if a user doesn't yet have access to his or her genetic data. These sample files are real genetic data files and are available for free for apps that use Sequencing.com's API.

To code Real-Time Personalization technology into apps, developers may [register for a free account](https://sequencing.com/user/register/) at Sequencing.com. App development with RTP is always free.

Implementation
======================================
To implement oAuth2 authentication for your app:

1) [Register](https://sequencing.com/user/register/) for a free account

2) Add [Sequencing.com's oAuth2 code](https://github.com/SequencingDOTcom/oAuth2-code-and-demo) from this repo to your app

3) [Generate an oAuth2 secret](https://sequencing.com/api-secret-generator) and insert the secret into the oAuth2 code

Once oAuth2 authentication is implemented, select one or more [app chains](https://sequencing.com/app-chains) that will provide information you can use to personalize your app. personalize your app. Each app chain is composed of 
* an **API request** to Sequencing.com
 * this request is secured using oAuth2
* *analysis* of the app user's genes
 * each app chain analyzes a specific trait or condition. 
 * there are thousands of app chains to choose from.
 * all analysis occurs in real-time at Sequencing.com
* an **API response** to your app. 
 * the information provided by the response allows your app to tailor itself to the app user based on the user's genes.
 * the documentation for each app chain provides a list of all possible API responses. The response for most app chains are simply 'Yes' or 'No'.

Example
* App Chain: This person likely needs to apply sunscreen with SPF +30 whenever it is sunny or even partly sunny.
* Possible responses: Yes, No, Insufficient Data, Error

Resources
======================================
* [App chains](https://sequencing.com/app-chains)
* [File selector code](https://github.com/SequencingDOTcom/File-Selector-code)
* [Developer center](https://sequencing.com/developer-center)
* [Developer Documentation](https://sequencing.com/developer-documentation/)

Maintainers
======================================
This repo is actively maintained by [Sequencing.com](https://sequencing.com/). Email the Sequencing.com bioinformatics team at gittaca@sequencing.com if you require any more information or just to say hola.

Contribute
======================================
We encourage you to passionately fork us. If interested in updating the master branch, please send us a pull request. If the changes contribute positively, we'll let it ride.
