//
//  MXImagePickerViewController.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 06/11/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import <MXParallaxHeader/MXScrollViewController.h>
#import "MXImagePickerController.h"

@implementation MXImagePickerController

- (IBAction)reduceHeader:(id)sender {
    self.parallaxHeader.height -= 10;
}

- (IBAction)extendHeader:(id)sender {
    self.parallaxHeader.height += 10;
}

@end
