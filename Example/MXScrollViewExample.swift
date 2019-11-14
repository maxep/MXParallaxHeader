// MXScrollViewExample.swift
//
// Copyright (c) 2019 Maxime Epain
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

    fileprivate var SpanichWhite : UIColor = #colorLiteral(red: 0.9960784314, green: 0.9921568627, blue: 0.9411764706, alpha: 1) // #FEFDF0
    
    @IBOutlet weak var scrollView: MXScrollView!
    @IBOutlet weak var table1: UITableView!
    @IBOutlet weak var table2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Parallax Header
        scrollView.parallaxHeader.load(withNibName: "StarshipHeader", bundle: nil, options: nil) // You can set the parallax header view from a nib.
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.mode = .fill

        table1.backgroundColor = SpanichWhite
        table1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        table2.backgroundColor = SpanichWhite
        table2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(format: "Row %ld", indexPath.row * 10)
        cell.backgroundColor = SpanichWhite;
        return cell
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("progress %f", scrollView.parallaxHeader.progress)
    }
}
