// MXScrollViewExample.m
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

#import <MXParallaxHeader/MXScrollView.h>
#import "MXScrollViewExample.h"

#define SPANISH_WHITE [UIColor colorWithRed:0.996 green:0.992 blue:0.941 alpha:1] /*#fefdf0*/

@interface MXScrollViewExample () <MXScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MXScrollView *scrollView;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;
@end

@implementation MXScrollViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.table1];
    [self.scrollView addSubview:self.table2];
    
    // Parallax Header
    self.scrollView.parallaxHeader.view = [NSBundle.mainBundle loadNibNamed:@"StarshipHeader" owner:self options:nil].firstObject; // You can set the parallax header view from a nib.
    self.scrollView.parallaxHeader.height = 300;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20;
}

// In this example I use manual layout for peformances
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.frame;
    
    //Update scroll view frame and content size
    self.scrollView.frame = frame;
    self.scrollView.contentSize = frame.size;
    
    //Update table 1 frame
    frame.size.width /= 2;
    frame.size.height -= self.scrollView.parallaxHeader.minimumHeight;
    self.table1.frame = frame;
    
    //Update table 2 frame
    frame.origin.x = frame.size.width;
    self.table2.frame = frame;
}

#pragma mark Properties

- (MXScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[MXScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [[UITableView alloc] init];
        _table1.dataSource  = self;
        _table1.backgroundColor = SPANISH_WHITE;
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [[UITableView alloc] init];
        _table2.dataSource  = self;
        _table2.backgroundColor = SPANISH_WHITE;
    }
    return _table2;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"progress %f", self.scrollView.parallaxHeader.progress);
}

#pragma mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    cell.backgroundColor = SPANISH_WHITE;
    
    return cell;
}

@end
