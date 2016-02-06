//
//  DemoDataCell.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved.
//

import UIKit

class DemoDataCell: UITableViewCell {
    
    @IBOutlet weak var demoTextLabel: UILabel!
    
    
    class func heightForRow(text: String) -> CGFloat {
        let font = UIFont.systemFontOfSize(13)
        
        let shadow: NSShadow = NSShadow()
        shadow.shadowOffset = CGSizeMake(0, -1)
        shadow.shadowBlurRadius = 0.5
        
        let paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = NSTextAlignment.Left
        
        let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.UsesFontLeading.rawValue,
            NSStringDrawingOptions.self)
        
        let rect: CGRect = text.boundingRectWithSize(
            CGSizeMake(280, CGFloat.max),
            options: options, // NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph, NSShadowAttributeName: shadow],
            context: nil)
        
        if CGRectGetHeight(rect) < 42.960938 {
            return 43.0
        } else {
            return CGRectGetHeight(rect) + 20
        }
    }
    
    
    class func prepareText(text: NSDictionary, FromFileType fileType: String) -> String {
        var preparedText = String()
        if fileType.containsString("Sample") {
            // working with sample file type
            let friendlyDesc1 = text.objectForKey("FriendlyDesc1") as? String
            let friendlyDesc2 = text.objectForKey("FriendlyDesc2") as? String
            preparedText += friendlyDesc1! + "\n" + friendlyDesc2!
        } else {
            // working with own file type
            let fileName = text.objectForKey("Name") as! String?
            preparedText += fileName!
        }
        return preparedText
    }
    
    
    class func prepareText(demoText: NSDictionary) -> String {
        var preparedText = String()
        let keys = NSArray(array: demoText.allKeys)
        let sortedKeys: NSArray = keys.sortedArrayUsingSelector("localizedCaseInsensitiveCompare:")
        for key in sortedKeys {
            let keyString = key as! String
            if demoText.objectForKey(key) is NSNull {
                preparedText = preparedText + keyString + ": \"" + "<null>\"" + "\n"
            } else if let value: String? = demoText.objectForKey(key) as! String? {
                preparedText = preparedText + keyString + ": \"" + value! + "\"\n"
            } else {
                preparedText = preparedText + keyString + ": \"" + "nil\"" + "\n"
            }
        }
        return preparedText
    }

}
