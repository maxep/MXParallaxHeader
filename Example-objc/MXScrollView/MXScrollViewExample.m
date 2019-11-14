// MXScrollViewExample.m
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

#import <MXParallaxHeader/MXScrollView.h>
#import "MXScrollViewExample.h"

#define SPANISH_WHITE [UIColor colorWithRed:0.996 green:0.992 blue:0.941 alpha:1] /*#fefdf0*/

@interface MXScrollViewExample () <MXScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet MXScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITableView *table1;
@property (nonatomic, strong) IBOutlet UITableView *table2;
@end

@implementation MXScrollViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Parallax Header
    [self.scrollView.parallaxHeader loadWithNibName:@"StarshipHeader" bundle:nil options:nil]; // You can set the parallax header view from a nib.
    self.scrollView.parallaxHeader.height = 300;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = self.topLayoutGuide.length;

    self.table1.backgroundColor = SPANISH_WHITE;
    [self.table1 registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];

    self.table2.backgroundColor = SPANISH_WHITE;
    [self.table2 registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    cell.backgroundColor = SPANISH_WHITE;
    
    return cell;
}

@end
