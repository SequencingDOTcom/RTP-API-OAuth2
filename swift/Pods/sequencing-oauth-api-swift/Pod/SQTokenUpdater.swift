//
//  SQTokenUpdater.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import Foundation

class SQTokenUpdater: NSObject {
    
    var timer: dispatch_source_t!
    
    // time interval lengh in seconds, in order to check token expiration periodically
    let SECONDS_TO_FIRE = 300

    
    // designated initializer
    static let instance = SQTokenUpdater()
    
    
    // MARK: - Timer methods
    
    // start timer should be launched once user is authorized, in order to start access_token being automatically refreshed
    func startTimer() -> Void {
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        if timer != nil {
            dispatch_source_set_timer(
                timer,
                dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(self.SECONDS_TO_FIRE) * NSEC_PER_SEC)),
                UInt64(self.SECONDS_TO_FIRE) * NSEC_PER_SEC,
                1 * NSEC_PER_SEC)
            
            dispatch_source_set_event_handler(timer, { () -> Void in
                // print("checking dates")
                let nowDate = NSDate()
                let oldToken = SQAuthResult.instance.token
                let expDate = oldToken.expirationDate
                if nowDate.compare(expDate) == NSComparisonResult.OrderedDescending {
                    // access token is expired, let's refresh it
                    self.executeRefreshTokenRequest()
                }
            })
            dispatch_resume(timer)
        }
    }
    
    // cancelTimer should be launched when user is loged out, in order to stop refreshing access_token
    func cancelTimer() -> Void {
        if timer != nil {
            dispatch_source_cancel(timer)
            timer = nil
        }
    }
    
    
    // MARK: - Refresh token method
    func executeRefreshTokenRequest() -> Void {
        SQServerManager.instance.postForNewTokenWithRefreshToken(SQAuthResult.instance.token) { (updatedToken, error) -> Void in
            if updatedToken != nil {
                // self.printToken(SQAuthResult.instance.token, withActivity: "oldToken")
                // self.printToken(updatedToken!, withActivity: "refreshedToken")
                SQAuthResult.instance.token = updatedToken!
                // self.printToken(SQAuthResult.instance.token, withActivity: "oldUpdatedToken")
            }
        }
    }
    
    /*
    func printToken(token: SQToken, withActivity activity: String) -> Void {
        print(activity)
        print("accessToken: \(token.accessToken)")
        print("expirationDate: \(token.expirationDate)")
        print("tokenType: \(token.tokenType)")
        print("scope: \(token.scope)")
        print("refreshToken: \(token.refreshToken)")
    } */

}
