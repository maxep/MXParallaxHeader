//
//  MXTwitterViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 26/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXScrollViewControllerExample.h"
#import "MXRefreshHeaderView.h"

@interface MXScrollViewControllerExample ()

@end

@implementation MXScrollViewControllerExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:@"XLPagerTabStrip" sender:self];
    
    // Parallax Header
    self.scrollView.parallaxHeader.view = [MXRefreshHeaderView instantiateFromNib];
    self.scrollView.parallaxHeader.height = 150;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
