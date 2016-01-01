//
//  Token.swift
//

import Foundation

class Token: NSObject {
    
    var accessToken     = String()
    var expirationDate  = NSDate()
    var tokenType       = String()
    var scope           = String()
    var refreshToken    = String()

}
