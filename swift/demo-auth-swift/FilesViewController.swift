//
//  FilesViewController.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved.
//

import UIKit

// ADD THIS POD IMPORT
import sequencing_oauth_api_swift

class FilesViewController: UITableViewController {
    
    let kMainQueue = dispatch_get_main_queue()
    let FILE_DETAILS_CONTROLLER_SEGUE_ID = "SHOW_DETAILS"
    
    var showDetailsButton = UIBarButtonItem()
    var segmentView = UIView()
    var fileTypePassed: String = ""
    
    // files source
    var filesArray = NSArray()
    var sampleFilesArray = NSArray()
    var ownFilesArray = NSArray()
    
    // file type selection and row selection
    var nowSelectedFileType = ""
    var nowSelectedFileIndexPath: NSIndexPath?
    
    // activity indicator with label
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "File selector"
        self.tableView.setEditing(true, animated: true)
        
        // showDetails button
        self.showDetailsButton = UIBarButtonItem(title: "Details", style: UIBarButtonItemStyle.Done, target: self, action: "showDetails")
        self.navigationItem.setRightBarButtonItem(self.showDetailsButton, animated: true)
        self.showDetailsButton.enabled = false
        
        // segmented control
        let fileTypeSelection = UISegmentedControl.init(items: ["My Files", "Sample Files"])
        fileTypeSelection.addTarget(self, action: "segmentControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        fileTypeSelection.sizeToFit()
        self.navigationItem.titleView = fileTypeSelection
        
        // select related segmentedIndex and load related own/sample files
        if self.fileTypePassed.containsString("Sample") {
            fileTypeSelection.selectedSegmentIndex = 1
            self.nowSelectedFileType = "Sample"
            self.loadSampleFiles()
            
        } else {
            fileTypeSelection.selectedSegmentIndex = 0
            self.nowSelectedFileType = "My"
            self.loadOwnFiles()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    func segmentControlAction(sender: UISegmentedControl) -> Void {
        self.nowSelectedFileIndexPath = nil
        self.showDetailsButton.enabled = false
        let emptyArray = NSArray()
        self.filesArray = emptyArray
        self.tableView.reloadData()
        
        if sender.selectedSegmentIndex == 1 {
            self.nowSelectedFileType = "Sample"
            if self.sampleFilesArray.count > 0 {
                self.filesArray = self.sampleFilesArray
                self.reloadTableViewWithAnimation()
            } else {
                self.loadSampleFiles()
            }
        } else {
            self.nowSelectedFileType = "My"
            if self.ownFilesArray.count > 0 {
                self.filesArray = self.ownFilesArray
                self.reloadTableViewWithAnimation()
            } else {
                self.loadOwnFiles()
            }
        }
    }
    
    
    // MARK: - TableView getting source data
    func loadSampleFiles() {
        self.startActivityIndicatorWithTitle("Loading sample files")
        SQAPI.instance.loadSampleFiles { (files) -> Void in
            if files != nil {
                dispatch_async(self.kMainQueue, { () -> Void in
                    self.sampleFilesArray = files!
                    self.filesArray = self.sampleFilesArray
                    self.stopActivityIndicator()
                    self.reloadTableViewWithAnimation()
                })
            } else {
                self.stopActivityIndicator()
                print("Can't load sample files")
            }
        }
    }
    
    func loadOwnFiles() {
        self.startActivityIndicatorWithTitle("Loading my files")
        SQAPI.instance.loadOwnFiles { (files) -> Void in
            if files != nil {
                dispatch_async(self.kMainQueue, { () -> Void in
                    self.ownFilesArray = files!
                    self.filesArray = self.ownFilesArray
                    self.stopActivityIndicator()
                    self.reloadTableViewWithAnimation()
                })
            } else {
                self.stopActivityIndicator()
                print("Can't load own files")
            }
        }
    }
    
    
    // MARK: - TableView delegates
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let demoText = self.filesArray.objectAtIndex(indexPath.row) as? NSDictionary {
            let text = DemoDataCell.prepareText(demoText, FromFileType: self.nowSelectedFileType)
            let height = DemoDataCell.heightForRow(text)
            return height
        } else {
            return CGFloat()
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filesArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DemoDataCell
        if let demoText = self.filesArray.objectAtIndex(indexPath.row) as? NSDictionary {
            let text = DemoDataCell.prepareText(demoText, FromFileType: self.nowSelectedFileType)
            cell.demoTextLabel.text = text
            cell.demoTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.tintColor = UIColor.blueColor()
        }
        return cell
    }
    
    
    func reloadTableViewWithAnimation() {
        var indexPath:[NSIndexPath] = [NSIndexPath]()
        for var i = 0; i < self.filesArray.count; i++ {
            indexPath.append(NSIndexPath(forRow: i, inSection: 0))
        }
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
    }
    
    
    
    // MARK: - Cells selection
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        // return UITableViewCellEditingStyle.None
        return unsafeBitCast(3, UITableViewCellEditingStyle.self)
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.nowSelectedFileIndexPath == nil {
            self.nowSelectedFileIndexPath = indexPath
        } else {
            self.tableView.deselectRowAtIndexPath(self.nowSelectedFileIndexPath!, animated: true)
            self.nowSelectedFileIndexPath = indexPath
        }
        self.showDetailsButton.enabled = true
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.nowSelectedFileIndexPath = nil
        self.showDetailsButton.enabled = false
    }
    
    
    // MARK: - Navigation
    func showDetails() {
        self.performSegueWithIdentifier(self.FILE_DETAILS_CONTROLLER_SEGUE_ID, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(DetailsViewController) {
            let destinationVC = segue.destinationViewController as! DetailsViewController
            if let row = self.nowSelectedFileIndexPath?.row {
                if let dict = self.filesArray.objectAtIndex(row) as? NSDictionary {
                    destinationVC.nowSelectedFile = dict
                }
            }
        }
    }
    
    
    // MARK: - Activity indicator
    func startActivityIndicatorWithTitle(title: String) -> Void {
        dispatch_async(self.kMainQueue) { () -> Void in
            self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 150, height: 50))
            self.strLabel.font = UIFont.systemFontOfSize(13)
            self.strLabel.text = title
            self.strLabel.textColor = UIColor.grayColor()
            
            self.messageFrame = UIView(frame: CGRect(x: self.tableView.frame.midX - 100, y: self.tableView.frame.midY - 100 , width: 250, height: 40))
            self.messageFrame.layer.cornerRadius = 15
            self.messageFrame.backgroundColor = UIColor.clearColor()
            
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.activityIndicator.startAnimating()
            
            self.messageFrame.addSubview(self.activityIndicator)
            self.messageFrame.addSubview(self.strLabel)
            self.tableView.addSubview(self.messageFrame)
        }
    }
    
    
    func stopActivityIndicator() -> Void {
        dispatch_async(kMainQueue) { () -> Void in
            self.activityIndicator.stopAnimating()
            self.messageFrame.removeFromSuperview()
        }
    }

}
