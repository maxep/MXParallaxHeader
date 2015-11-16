// MXImagePickerController.m
//
// Copyright (c) 2015 Maxime Epain
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

#import "MXChildViewController.h"

@interface MXChildViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIImageView *header;
@end

@implementation MXChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.delegate = self;
    
    // Parallax Header
    self.header = [UIImageView new];
    self.header.image = [UIImage imageNamed:@"success-baby"];
    self.header.contentMode = UIViewContentModeScaleAspectFill;
    
    self.parallaxHeader.view = self.header;
    self.parallaxHeader.height = 150;
    self.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.parallaxHeader.minimumHeight = 20;
}

- (IBAction)reduceHeader:(id)sender {
    self.parallaxHeader.height -= 10;
}

- (IBAction)extendHeader:(id)sender {
    self.parallaxHeader.height += 10;
}

#pragma mark <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.header.image = info[UIImagePickerControllerOriginalImage];
}

@end
