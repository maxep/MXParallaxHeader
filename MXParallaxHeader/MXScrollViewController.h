// MXScrollViewController.h
//
// Copyright (c) 2017 Maxime Epain
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

#import "MXScrollView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The MXScrollViewController class.
 */
@interface MXScrollViewController : UIViewController

/**
 The scroll view container.
 */
@property (nonatomic,readonly) MXScrollView *scrollView;

/**
 The parallax header view controller to be added to the scroll view.
 */
@property (nonatomic,strong,nullable) UIViewController *headerViewController;

/**
 The child view controller to be added to the scroll view.
 */
@property (nonatomic,strong,nullable) UIViewController *childViewController;

@end

/**
 UIViewController category to let childViewControllers easily access their parallax header.
 */
@interface UIViewController (MXParallaxHeader)

/**
 The parallax header.
 */
@property (nonatomic,readonly,nullable) MXParallaxHeader *parallaxHeader;

@end

/**
 The MXParallaxHeaderSegue class creates a segue object to get the parallax header view controller from storyboard.
 */
@interface MXParallaxHeaderSegue : UIStoryboardSegue

@end

/**
 The MXScrollViewControllerSegue class creates a segue object to get the child view controller from storyboard.
 */
@interface MXScrollViewControllerSegue : UIStoryboardSegue

@end

NS_ASSUME_NONNULL_END
