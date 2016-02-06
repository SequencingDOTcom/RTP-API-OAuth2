//
//  SQRequestHelper.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import Foundation

class SQRequestHelper : NSObject {
    
    // var redirect_uri: String = ""
    var redirect_uri: String = ""
    
    
    // designated initializer
    static let instance = SQRequestHelper()
    
    
    // MARK: - Save redirect_uri var
    func rememberRedirectUri(redirect_uri: String) -> Void {
        self.redirect_uri = redirect_uri
    }
    
    
    // MARK: - Request methods
    func verifyRequestForRedirectBack(request: NSURLRequest) -> Bool {
        let currentURL: NSString = request.URL!.absoluteString
        let redirectURL = self.redirect_uri + "?"
        
        if currentURL.containsString(redirectURL) {
            return true
        }
        return false
    }
    
    
    func parseRequest(request: NSURLRequest) -> NSMutableDictionary {
        let dict: NSMutableDictionary = NSMutableDictionary()
        var query = request.URL!.description
        let array: Array = query.componentsSeparatedByString("?")
        if array.count > 1 {
            query = array.last!
        }
        let params: Array = query.componentsSeparatedByString("&")
        for param in params {
            let elements = param.componentsSeparatedByString("=")
            if elements.count == 2 {
                let key = elements.first!.stringByRemovingPercentEncoding
                let val = elements.last!.stringByRemovingPercentEncoding
                dict.setObject(val!, forKey: key!)
            }
        }
        return dict
    }
    
    
    
}