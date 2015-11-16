// MXScrollViewExample.swift
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

class MXScrollViewExample: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: MXScrollView!
    
    var table1: UITableView!
    var table2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Parallax Header
        let header = UIImageView()
        header.image = UIImage(named:"success-baby")
        header.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.scrollView.parallaxHeader.view = header
        self.scrollView.parallaxHeader.height = 150
        self.scrollView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
        self.scrollView.parallaxHeader.minimumHeight = 20
        
        self.table1 = UITableView()
        self.table1.dataSource = self;
        self.scrollView.addSubview(self.table1)
        
        self.table2 = UITableView()
        self.table2.dataSource = self;
        self.scrollView.addSubview(self.table2)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = self.view.frame
        
        self.scrollView.frame = frame
        self.scrollView.contentSize = frame.size
        
        frame.size.width /= 2
        frame.size.height -= self.scrollView.parallaxHeader.minimumHeight
        self.table1.frame = frame
        
        frame.origin.x = frame.size.width
        self.table2.frame = frame
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        cell!.textLabel!.text = String(format: "Row %ld", indexPath.row * 10)
        return cell!
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("progress %f", scrollView.parallaxHeader.progress)
    }
}
