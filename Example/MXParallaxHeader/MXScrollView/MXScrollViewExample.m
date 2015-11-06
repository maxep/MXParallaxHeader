//
//  MXViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 29/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXScrollViewExample.h"

@interface MXScrollViewExample () <MXScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MXScrollView *scrollView;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;
@end

@implementation MXScrollViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Parallax Header
    UIImageView *header = [UIImageView new];
    header.image = [UIImage imageNamed:@"success-baby"];
    header.contentMode = UIViewContentModeScaleAspectFill;
    
    self.scrollView.parallaxHeader.view = header;
    self.scrollView.parallaxHeader.height = 150;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.view.frame;
    
    self.scrollView.frame = frame;
    self.scrollView.contentSize = frame.size;
    
    frame.size.width /= 2;
    frame.size.height -= self.scrollView.parallaxHeader.minimumHeight;
    self.table1.frame = frame;
    
    frame.origin.x = frame.size.width;
    self.table2.frame = frame;
}

#pragma mark Properties

- (MXScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[MXScrollView alloc] init];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [[UITableView alloc] init];
        _table1.delegate    = self;
        _table1.dataSource  = self;
        [self.scrollView addSubview:_table1];
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [[UITableView alloc] init];
        _table2.delegate    = self;
        _table2.dataSource  = self;
        [self.scrollView addSubview:_table2];
    }
    return _table2;
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
    
    return cell;
}

@end
