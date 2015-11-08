// MXScrollViewControllerExample.swift
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

class MXScrollViewControllerExample: MXScrollViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var header: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Parallax Header
        self.header = UIImageView()
        self.header.image = UIImage(named:"success-baby")
        self.header.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.scrollView.parallaxHeader.view = header
        self.scrollView.parallaxHeader.height = 150
        self.scrollView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
        self.scrollView.parallaxHeader.minimumHeight = 20
        
        self.performSegueWithIdentifier("Photo", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "Photo") {
            let nav = segue.destinationViewController as! UINavigationController;
            var controller = nav.topViewController as! UIImagePickerController;
            controller = controller.dynamicType.init()
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            controller.delegate = self;
        }
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.header.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
    }
}
