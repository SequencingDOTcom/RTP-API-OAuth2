//
//  SQHttpHelper.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

/**
* Provides various functionality for accessing HTTP resources via common httpRequest
*/

import Foundation

typealias HttpCallback = (responseText: NSString?, response: NSURLResponse?, error: NSError?) -> Void

class SQHttpHelper: NSObject {
    
    // designated initializer
    static let instance = SQHttpHelper()
    
    
    func execHttpRequestWithUrl(
        url: String,
        method: String,
        headers: NSDictionary?,
        username: String?,
        password: String?,
        token: String?,
        authScope: String,
        parameters: Dictionary<String, String>?,
        callback: HttpCallback) -> Void {
            
            // create request by url
            let urlRequest = NSURL(string: url)
            let request = NSMutableURLRequest(URL: urlRequest!)
            
            // set request method
            request.HTTPMethod = method
            
            // add headers (if any) to request HTTPHeader
            if headers != nil {
                for key in headers!.allKeys {
                    let headerKey = key as! String
                    if let headerValue = headers?.valueForKey(headerKey) as! String? {
                        request.addValue(headerValue, forHTTPHeaderField: headerKey)
                    }
                }
            }
            
            // setting request authscope (for Authorization httpHeaderField) - either for Basic or for Bearer
            if authScope == "Basic" {
                if let stringUsernameAndPassword: String! = username! + ":" + password! {
                    let authData: NSData? = stringUsernameAndPassword.dataUsingEncoding(NSASCIIStringEncoding)
                    if let authDataEncoded = authData?.base64EncodedStringWithOptions([]) {
                        let authValue = String(format: "%@ %@", authScope, authDataEncoded)
                        request.setValue(authValue, forHTTPHeaderField: "Authorization")
                    }
                }
            } else if authScope == "Bearer" {
                if token != nil {
                    let authValue = String(format: "%@ %@", authScope, token!)
                    request.setValue(authValue, forHTTPHeaderField: "Authorization")
                }
            }
            
            // adding parameters to request HTTPBody
            if parameters != nil {
                let parametersString = self.urlEncodedString(parameters!)
                request.HTTPBody = parametersString.dataUsingEncoding(NSUTF8StringEncoding)
            }
            
            request.timeoutInterval = 10
            request.HTTPShouldHandleCookies = false
            
            let dataTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, serverResponse, serverError) -> Void in
                if data != nil {
                    if let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                        callback(responseText: dataString, response: nil, error: nil)
                    }
                }
                if serverError != nil {
                    callback(responseText: nil, response: serverResponse, error: serverError)
                }
            }
            dataTask.resume()
    }
    
    
    func urlEncodedString(dict: Dictionary<String, String>) -> String {
        var parts = [String]()
        for key in dict.keys {
            if let value = dict[key] {
                let part = self.urlEncode(key) + "=" + self.urlEncode(value)
                parts.append(part)
            }
        }
        let joinedString: String = parts.joinWithSeparator("&")
        return joinedString
    }
    
    
    func urlEncode(string: String) -> String {
        if let encodedString = string.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            return encodedString
        } else {
            return ""
        }
        // deprecated method:  .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }
    
}
