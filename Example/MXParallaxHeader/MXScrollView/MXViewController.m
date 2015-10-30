//
//  MXViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 29/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXViewController.h"
#import "MXRefreshHeaderView.h"

@interface MXViewController ()

@end

@implementation MXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:@"mx_scroll_view_controller" sender:self];
    
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
