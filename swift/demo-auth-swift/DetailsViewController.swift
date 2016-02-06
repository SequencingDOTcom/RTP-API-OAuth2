//
//  DetailsViewController.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var fileDetails: UILabel!
    
    var nowSelectedFileType: String = ""
    var nowSelectedFile = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "File details"
        
        self.fileDetails.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.fileDetails.numberOfLines = 0
        
        self.fileDetails.text = DemoDataCell.prepareText(self.nowSelectedFile)
        self.fileDetails.sizeToFit()
    }
    
}
