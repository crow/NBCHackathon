//
//  WillToLiveViewController.swift
//  NBCHackathon
//
//  News view controller that reduces one's will to live.
//
//  Created by David Crow on 10/22/16.
//  Copyright © 2016 Urban Airship. All rights reserved.
//

import UIKit

class WillToLiveViewController: UIViewController {

    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        NSURL *websiteUrl = [NSURL URLWithString:@"http://www.google.com"];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
//        [myWebView loadRequest:urlRequest];

        let url:NSURL = NSURL(string: "http://www.nbcnews.com")!
        let urlRequest = NSURLRequest(url: url as URL)
        self.webView.loadRequest(urlRequest as URLRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
