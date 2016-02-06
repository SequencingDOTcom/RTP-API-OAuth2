//
//  SQToken.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import Foundation

public class SQToken: NSObject {
    
    public var accessToken     = String()
    public var expirationDate  = NSDate()
    public var tokenType       = String()
    public var scope           = String()
    public var refreshToken    = String()

}
