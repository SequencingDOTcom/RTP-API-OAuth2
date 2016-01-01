//
//  ServerManager.swift
//

import UIKit
import Foundation

class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager() //designated initializer
    
    // parameters for authorization request
    let authURL: String         = "https://sequencing.com/oauth2/authorize"
    let redirect_uri: String    = "authapp://Default/Authcallback"
    let response_type: String   = "code"
    let state: String           = "statecodecallbackmd5"
    let clientID: String        = "oAuth2 Demo ObjectiveC"
    let scope: String           = "demo"
    
    // parameters for token request
    let tokenURL: String        = "https://sequencing.com/oauth2/token"
    let client_secret: String   = "RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g"
    let grant_type: String      = "authorization_code"
    
    // parameters for demo data request
    let apiURL: String          = "https://api.sequencing.com"
    let demoPath: String        = "/DataSourceList?sample=true"
    
    // activity indicator with label
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let mainVC = UIApplication.sharedApplication().windows.first!.rootViewController
    
    let kMainQueue = dispatch_get_main_queue()
    
    
    // MARK: Functions
    func authorizeUser(completion: (demoData: NSArray?) -> Void) -> Void {
        self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        let client_id: String = clientID.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let urlString = authURL + "?" +
            "redirect_uri=" + redirect_uri + "&" +
            "response_type=" + response_type + "&" +
            "state=" + state + "&" +
            "client_id=" + client_id + "&" +
            "scope=" + scope
        let urlRequest: NSURL = NSURL(string: urlString)!
        
        print("===== 1st request (authorize user) =====")
        let loginViewController: LoginViewController = LoginViewController.init(url: urlRequest) { (response) -> Void in
            if response != nil {
                // first, must check if "state" from response matches "state" in request
                let stateInResponse = response?.objectForKey("state") as! String
                if stateInResponse != self.state {
                    print("state mismatch, response is being spoofed")
                    completion(demoData: nil)
                } else {
                    
                    // state matches - we can proceed with token request
                    self.startActivityIndicator()
                    print("===== 2nd request (getting token) =====")
                    let codeFromResponse = response?.objectForKey("code") as! String
                    self.postForTokenWithCode(codeFromResponse, completion: { (token, error) -> Void in
                        if token != nil {
                            // print(token?.accessToken)
                            
                            print("===== 3rd request (getting demo data) =====")
                            self.getForDemoDataWithToken(token!, completion: { (demoData, error) -> Void in
                                if demoData != nil {
                                    self.stopActivityIndicator()
                                    completion(demoData: demoData)
                                    
                                } else  if error != nil {
                                    print(error)
                                    self.stopActivityIndicator()
                                    completion(demoData: nil)
                                }
                            })
                            
                        } else if error != nil {
                            print(error)
                            self.stopActivityIndicator()
                            completion(demoData: nil)
                        }
                    })
                }
            } else {
                self.stopActivityIndicator()
                completion(demoData: nil)
            }
        }
        let nav = UINavigationController(rootViewController: loginViewController)
        let mainVC = UIApplication.sharedApplication().windows.first!.rootViewController
        mainVC!.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    func postForTokenWithCode(code: String, completion: (token: Token?, error: NSError?) -> Void) -> Void {
        let grant_typeString: String = "" + self.grant_type
        let redirect_uriString: String = "" + self.redirect_uri
        let postParameters: [String: String] = ["grant_type": grant_typeString, "code": code, "redirect_uri": redirect_uriString]
        
        HttpHelper.sharedInstance.execHttpRequestWithUrl(
            tokenURL,
            method: "POST",
            headers: nil,
            username: clientID,
            password: client_secret,
            token: nil,
            authScope: "Basic",
            parameters: postParameters) { (responseText, response, error) -> Void in
                if responseText != nil {
                    let jsonData = responseText?.dataUsingEncoding(NSUTF8StringEncoding)
                    do {
                        if let jsonParsed = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as? NSDictionary {
                            let token = Token()
                            
                            if let value = jsonParsed.objectForKey("access_token") as! String? {
                                token.accessToken = value
                            }
                            if let value = jsonParsed.objectForKey("expires_in") as! String? {
                                let myDouble: NSTimeInterval = Double(value)!
                                token.expirationDate = NSDate(timeIntervalSinceNow: myDouble)
                            }
                            if let value = jsonParsed.objectForKey("token_type") as! String? {
                                token.tokenType = value
                            }
                            if let value = jsonParsed.objectForKey("scope") as! String? {
                                token.scope = value
                            }
                            if let value = jsonParsed.objectForKey("refresh_token") as! String? {
                                token.refreshToken = value
                            }
                            completion(token: token, error: nil)
                        }
                    } catch let error as NSError {
                        print("json error" + error.localizedDescription)
                    }
                } else if error != nil {
                    print("error: ")
                    print(error)
                    print("response: ")
                    print(response)
                    completion(token: nil, error: error)
                }
        }
        
    }
    
    func getForDemoDataWithToken(token: Token, completion: (demoData: NSArray?/*Array<String>?*/, error: NSError?) -> Void) -> Void {
        let apiUrlForDemo: String = self.apiURL + self.demoPath
        HttpHelper.sharedInstance.execHttpRequestWithUrl(
            apiUrlForDemo,
            method: "GET",
            headers: nil,
            username: nil,
            password: nil,
            token: token.accessToken,
            authScope: "Bearer",
            parameters: nil) { (responseText, response, error) -> Void in
                if responseText != nil {
                    let jsonData = responseText?.dataUsingEncoding(NSUTF8StringEncoding)
                    do {
                        if let jsonParsed = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as? NSArray {
                            completion(demoData: jsonParsed, error: nil)
                        }
                    } catch let error as NSError {
                        print("json error" + error.localizedDescription)
                    }
                    
                } else if error != nil {
                    print("error: ")
                    print(error)
                    print("response: ")
                    print(response)
                    completion(demoData: nil, error: error)
                }
                
        }
    }
    
    // MARK: Activity indicator
    func startActivityIndicator() -> Void {
        dispatch_async(kMainQueue) { () -> Void in
            if self.mainVC != nil {
                self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 150, height: 50))
                self.strLabel.text = "Getting demo data"
                self.strLabel.textColor = UIColor.grayColor()
                
                self.messageFrame = UIView(frame: CGRect(x: self.mainVC!.view.frame.midX - 100, y: self.mainVC!.view.frame.midY - 25 , width: 250, height: 40))
                self.messageFrame.layer.cornerRadius = 15
                self.messageFrame.backgroundColor = UIColor.clearColor()
                
                self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                self.activityIndicator.startAnimating()
                
                self.messageFrame.addSubview(self.activityIndicator)
                self.messageFrame.addSubview(self.strLabel)
                self.mainVC!.view.addSubview(self.messageFrame)
            }
        }
    }
    
    func stopActivityIndicator() -> Void {
        dispatch_async(kMainQueue) { () -> Void in
            self.activityIndicator.stopAnimating()
            self.messageFrame.removeFromSuperview()
        }
    }

}
