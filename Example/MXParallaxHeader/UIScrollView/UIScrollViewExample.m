//
//  MXViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 10/28/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "UIScrollViewExample.h"
#import <MXParallaxHeader/MXParallaxHeader.h>

@interface UIScrollViewExample ()
@end

@implementation UIScrollViewExample

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Parallax Header
    UIImageView *header = [UIImageView new];
    header.image = [UIImage imageNamed:@"success-baby"];
    header.contentMode = UIViewContentModeScaleAspectFill;
    
    self.tableView.parallaxHeader.view = header;
    self.tableView.parallaxHeader.height = 150;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.parallaxHeader.height = indexPath.row * 10;
}

#pragma mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Height %ld", (long)indexPath.row * 10];
    return cell;
}

@end
