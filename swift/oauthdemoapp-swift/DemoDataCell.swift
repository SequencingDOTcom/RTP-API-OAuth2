//
//  DemoDataCell.swift
//

import UIKit

class DemoDataCell: UITableViewCell {
    
    @IBOutlet weak var demoTextLable: UILabel!
    
    class func heightForRow(text: String) -> CGFloat {
        let font: UIFont = UIFont.systemFontOfSize(17)
        
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
            CGSizeMake(300, CGFloat.max),
            options: options, // NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph, NSShadowAttributeName: shadow],
            context: nil)
        
        return CGRectGetHeight(rect)+28
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
