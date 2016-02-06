//
//  SQLoginViewController.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import UIKit
import WebKit

class SQLoginViewController: UIViewController, UIWebViewDelegate {
    
    typealias LoginCompletionBlock = (response: NSMutableDictionary?) -> Void
    
    var completionBlock: LoginCompletionBlock
    var webView: UIWebView?
    var activityIndicator: UIActivityIndicatorView
    var url: NSURL
    
    
    init(url: NSURL, completionBlock: LoginCompletionBlock) {
        self.url = url
        self.completionBlock = completionBlock
        self.activityIndicator = UIActivityIndicatorView()
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add webView container
        var rect: CGRect = self.view.bounds
        rect.origin = CGPointZero
        let webView: UIWebView = UIWebView.init(frame: rect)
        webView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.view.addSubview(webView)
        self.webView = webView
        
        // add cancel button for viewController
        let cancelButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "actionCancel:")
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        
        // add activity indicator
        self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.navigationItem.titleView = self.activityIndicator
        
        // open login page from url with params
        let request: NSURLRequest = NSURLRequest(URL: self.url)
        webView.delegate = self
        webView.loadRequest(request)
        
    }
    
    deinit {
        self.webView?.delegate = nil
    }
    
    
    // MARK: - Actions
    func actionCancel(sender: UIBarButtonItem) -> Void {
        self.completionBlock(response: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if SQRequestHelper.instance.verifyRequestForRedirectBack(request) {
            self.webView?.delegate = nil
            self.completionBlock(response: SQRequestHelper.instance.parseRequest(request))
            self.dismissViewControllerAnimated(true, completion: nil)
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.activityIndicator.stopAnimating()
    }
    
}
