//
//  SQAPI.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import Foundation

public class SQAPI: NSObject {
    
    // designated initializer
    public static let instance = SQAPI()
    
    
    // MARK: - API methods
    public func loadOwnFiles(result: (files: NSArray?) -> Void) -> Void {
        SQServerManager.instance.getForOwnFilesWithToken(SQAuthResult.instance.token) { (ownFiles, error) -> Void in
            if ownFiles != nil {
                result(files: ownFiles!)
            } else {
                result(files: nil)
            }
        }
    }
    
    
    public func loadSampleFiles(result: (files: NSArray?) -> Void) -> Void {
        SQServerManager.instance.getForSampleFilesWithToken(SQAuthResult.instance.token) { (sampleFiles, error) -> Void in
            if sampleFiles != nil {
                result(files: sampleFiles!)
            } else {
                result(files: nil)
            }
        }
    }
    
}
