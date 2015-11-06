//
//  MXTwitterViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 26/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXScrollViewControllerExample.h"

@interface MXScrollViewControllerExample () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIImageView *header;
@end

@implementation MXScrollViewControllerExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Parallax Header
    self.header = [UIImageView new];
    self.header.image = [UIImage imageNamed:@"success-baby"];
    self.header.contentMode = UIViewContentModeScaleAspectFill;
    
    self.scrollView.parallaxHeader.view = self.header;
    self.scrollView.parallaxHeader.height = 150;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20;
    
    [self performSegueWithIdentifier:@"Photo" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Photo"]) {
        UINavigationController *nav = segue.destinationViewController;
        UIImagePickerController *controller = (id)[nav.topViewController init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
    }
}

#pragma mark <UIImagePickerControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.header.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

@end
