//
//  ViewController.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved.
//

import UIKit

// ADD THIS POD IMPORT
import sequencing_oauth_api_swift

class StartViewController: UIViewController {

    // THESE ARE THE APPLICATION PARAMETERS
    // SPECIFY THEM HERE
    let CLIENT_ID: String       = "oAuth2 Demo ObjectiveC"
    let CLIENT_SECRET: String   = "RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g"
    let REDIRECT_URI: String    = "authapp://Default/Authcallback"
    let SCOPE: String           = "demo"
    
    var loginButton = UIBarButtonItem()
    let kMainQueue = dispatch_get_main_queue()
    let FILES_CONTROLLER_SEGUE_ID = "GET_FILES"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Done, target: self, action: "loginButtonPressed:")
        self.navigationItem.setLeftBarButtonItem(self.loginButton, animated: true)
        self.title = "OAuth demo application"
        
        SQOAuth.instance.registrateApplicationParametersClientID(self.CLIENT_ID, ClientSecret: self.CLIENT_SECRET, RedirectUri: self.REDIRECT_URI, Scope: self.SCOPE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    func loginButtonPressed(sender: UIButton) -> Void {
        SQOAuth.instance.authorizeUserWithResult { (authResult) -> Void in
            if authResult.isAuthorized {
                
                dispatch_async(self.kMainQueue, { () -> Void in
                    self.loginButton.title = "Logout"
                    
                    let ownFilesButton: UIButton = UIButton(type: UIButtonType.RoundedRect)
                    ownFilesButton.setTitle("My Files", forState: UIControlState.Normal)
                    ownFilesButton.sizeToFit()
                    ownFilesButton.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 20)
                    ownFilesButton.addTarget(self, action: "getFiles:", forControlEvents: UIControlEvents.TouchUpInside)
                    self.view.addSubview(ownFilesButton)
                    
                    let sampleFilesButton: UIButton = UIButton(type: UIButtonType.RoundedRect)
                    sampleFilesButton.setTitle("Sample Files", forState: UIControlState.Normal)
                    sampleFilesButton.sizeToFit()
                    sampleFilesButton.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 + 20)
                    sampleFilesButton.addTarget(self, action: "getFiles:", forControlEvents: UIControlEvents.TouchUpInside)
                    self.view.addSubview(sampleFilesButton)
                })
            } else {
                print("user is not authorized")
            }
        }
    }
    
    
    // MARK: - Navigation
    func getFiles(sender: UIButton) {
        self.performSegueWithIdentifier(self.FILES_CONTROLLER_SEGUE_ID, sender: sender.titleLabel?.text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(FilesViewController) {
            if sender != nil {
                let destinationVC = segue.destinationViewController as! FilesViewController
                destinationVC.fileTypePassed = sender as! String
            }
        }
    }


}

