// MXScrollViewExample.swift
//
// Copyright (c) 2017 Maxime Epain
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

    fileprivate var SpanichWhite : UIColor = UIColor(colorLiteralRed: 0.996, green: 0.992, blue: 0.941, alpha: 1) /*#fefdf0*/
    
    var scrollView: MXScrollView!
    var table1: UITableView!
    var table2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Parallax Header
        scrollView = MXScrollView()
        scrollView.parallaxHeader.view = Bundle.main.loadNibNamed("StarshipHeader", owner: self, options: nil)?.first as? UIView // You can set the parallax header view from a nib.
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        scrollView.parallaxHeader.minimumHeight = 20
        view.addSubview(scrollView)
        
        table1 = UITableView()
        table1.dataSource = self;
        table1.backgroundColor = SpanichWhite
        scrollView.addSubview(table1)
        
        table2 = UITableView()
        table2.dataSource = self;
        table2.backgroundColor = SpanichWhite
        scrollView.addSubview(table2)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.frame
        
        scrollView.frame = frame
        scrollView.contentSize = frame.size
        
        frame.size.width /= 2
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        table1.frame = frame
        
        frame.origin.x = frame.size.width
        table2.frame = frame
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifier)
        }
        cell!.textLabel!.text = String(format: "Row %ld", indexPath.row * 10)
        cell!.backgroundColor = SpanichWhite;
        return cell!
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("progress %f", scrollView.parallaxHeader.progress)
    }
}
