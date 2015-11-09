// MXScrollViewController.m
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

#import <objc/runtime.h>
#import "MXScrollViewController.h"

@interface MXScrollViewController ()
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation MXScrollViewController

@synthesize  scrollView = _scrollView;

static void * const kMXScrollViewControllerKVOContext = (void*)&kMXScrollViewControllerKVOContext;

- (void)loadView {
    self.view = self.scrollView;
}

#pragma mark Properties

- (MXScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[MXScrollView alloc] init];
        
        [_scrollView.parallaxHeader addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(minimumHeight))
                                        options:NSKeyValueObservingOptionNew
                                        context:kMXScrollViewControllerKVOContext];
    }
    return _scrollView;
}

- (void)setChildViewController:(UIViewController<MXScrollViewDelegate> *)childViewController {
    if (childViewController && _childViewController != childViewController) {
        
        [self addChildViewController:childViewController];
        [childViewController didMoveToParentViewController:self];
        
        self.scrollView.delegate = childViewController;
        
        [self.scrollView addSubview:childViewController.view];
        self.scrollView.contentSize = self.childViewController.view.frame.size;
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *binding  = @{@"v" : childViewController.view};
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:binding]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:childViewController.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0]];
        
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:childViewController.view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1
                                                              constant:-self.scrollView.parallaxHeader.minimumHeight];
        
        [self.scrollView addConstraint:self.heightConstraint];
        
        //Set UIViewController's parallaxHeader property
        objc_setAssociatedObject(childViewController, @selector(parallaxHeader), self.scrollView.parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [_childViewController.view removeFromSuperview];
    [_childViewController removeFromParentViewController];
    _childViewController = childViewController;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewControllerKVOContext) {
        
        if (self.heightConstraint && [keyPath isEqualToString:NSStringFromSelector(@selector(minimumHeight))]) {
            self.heightConstraint.constant = -self.scrollView.parallaxHeader.minimumHeight;
            [self.scrollView setNeedsLayout];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.scrollView.parallaxHeader removeObserver:self forKeyPath:NSStringFromSelector(@selector(minimumHeight))];
}

@end

#pragma mark UIViewController category

@implementation UIViewController (MXParallaxHeader)

- (MXParallaxHeader *)parallaxHeader {
    MXParallaxHeader *parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader && self.parentViewController) {
        return self.parentViewController.parallaxHeader;
    }
    return parallaxHeader;
}

@end

#pragma mark MXScrollViewControllerSegue class

@implementation MXScrollViewControllerSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[MXScrollViewController class]]) {
        MXScrollViewController *svc = self.sourceViewController;
        svc.childViewController = self.destinationViewController;
    }
}

@end


