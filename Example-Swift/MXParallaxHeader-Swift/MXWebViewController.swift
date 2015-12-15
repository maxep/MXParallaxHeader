// MXChildViewController.swift
//
// Copyright (c) 2015 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import MXParallaxHeader

class MXWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: "https://dribbble.com/search?q=spaceship")!)
        self.webView.loadRequest(request)
        
        // Parallax Header        
        self.parallaxHeader!.view = MXFalconHeader.instanciateFromNib()
        self.parallaxHeader!.height = 300
        self.parallaxHeader!.mode = MXParallaxHeaderMode.Fill
        self.parallaxHeader!.minimumHeight = 20
    }
    
    @IBAction func back(sender: AnyObject) {
        self.webView.goBack()
    }
    
    @IBAction func forward(sender: AnyObject) {
        self.webView.goForward()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.webView.reload()
    }
}
