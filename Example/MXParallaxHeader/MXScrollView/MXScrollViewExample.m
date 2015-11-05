//
//  MXViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 29/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXScrollViewExample.h"
#import "MXRefreshHeaderView.h"

@interface MXScrollViewExample () <MXScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;
@end

@implementation MXScrollViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat minimumHeight = 20;
    
    //Add MXScrollView
    MXScrollView *scrollView = [MXScrollView new];
    scrollView.delegate = self;
    scrollView.parallaxHeader.view = [MXRefreshHeaderView instantiateFromNib];
    scrollView.parallaxHeader.height = 150;
    scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    scrollView.parallaxHeader.minimumHeight = minimumHeight;
    
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *binding  = @{@"scrollView" : scrollView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:binding]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:binding]];
    
    //Add table views
    [scrollView addSubview:self.table1];
    [scrollView addSubview:self.table2];
    
    self.table1.translatesAutoresizingMaskIntoConstraints = NO;
    self.table2.translatesAutoresizingMaskIntoConstraints = NO;
    binding  = @{@"table1" : self.table1, @"table2" : self.table2};
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table1][table2]|" options:0 metrics:nil views:binding]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table1]|" options:0 metrics:nil views:binding]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table2]|" options:0 metrics:nil views:binding]];
    
    
    //Setting constraints using the minimum header height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.table1
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:0.5
                                                                 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.table1
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:-minimumHeight]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.table2
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.5
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.table2
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:-minimumHeight]];
}

#pragma mark Properties

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [[UITableView alloc] init];
        _table1.delegate    = self;
        _table1.dataSource  = self;
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [[UITableView alloc] init];
        _table2.delegate    = self;
        _table2.dataSource  = self;
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

#pragma mark <MXScrollViewDelegate>

- (BOOL)scrollView:(MXScrollView *)scrollView shouldScrollWithSubView:(UIView *)subView {
    return [subView isDescendantOfView:self.table1];
}

@end
