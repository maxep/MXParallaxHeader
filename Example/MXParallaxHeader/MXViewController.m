//
//  MXViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 10/28/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "MXViewController.h"
#import <MXParallaxHeader/MXParallaxHeader.h>
#import "MXRefreshHeaderView.h"

@interface MXViewController ()
@property (nonatomic,strong) MXParallaxHeader *header;
@end

@implementation MXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Parallax Header
    self.header = [[MXParallaxHeader alloc] initWithView:[MXRefreshHeaderView instantiateFromNib] height:150 mode:MXParallaxHeaderModeFill];
    self.header.minimumHeight = 20;
    self.tableView.parallaxHeader = self.header;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.header.height = indexPath.row * 10;
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
