//
//  ViewController.swift
//

import UIKit

class ViewController: UITableViewController {
    
    var demoDataArray: NSArray = NSArray()
    var loginButton: UIBarButtonItem?
    var token: Token = Token()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeButton: UIBarButtonItem = UIBarButtonItem(title: "login", style: UIBarButtonItemStyle.Done, target: self, action: "loginButtonPressed:")
        self.navigationItem.setLeftBarButtonItem(homeButton, animated: true)
        self.title = "OAuth demo application"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    func loginButtonPressed(sender: UIButton) -> Void {
        ServerManager.sharedInstance.authorizeUser { (demoData) -> Void in
            if demoData != nil {
                self.demoDataArray = demoData!
                // print(self.demoDataArray)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var indexPath:[NSIndexPath] = [NSIndexPath]()
                    for var i = 0; i < self.demoDataArray.count; i++ {
                        indexPath.append(NSIndexPath(forRow: i, inSection: 0))
                    }
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Top)
                    self.tableView.endUpdates()
                })
            }
        }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let demoText = self.demoDataArray.objectAtIndex(indexPath.row) as? NSDictionary {
            let text = DemoDataCell.prepareText(demoText)
            let height = DemoDataCell.heightForRow(text)
            return height
        } else {
            return CGFloat()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoDataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DemoDataCell
        if let demoText = self.demoDataArray.objectAtIndex(indexPath.row) as? NSDictionary {
            let text = DemoDataCell.prepareText(demoText)
            cell.demoTextLable.text = text
            cell.demoTextLable.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        return cell
    }

}

