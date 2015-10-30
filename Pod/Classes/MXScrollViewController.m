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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Properties

- (MXScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[MXScrollView alloc] init];
        _scrollView.delegate = self;
        
        [_scrollView.parallaxHeader addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(minimumHeight))
                                        options:NSKeyValueObservingOptionNew
                                        context:kMXScrollViewControllerKVOContext];
    }
    return _scrollView;
}

- (void)setViewController:(UIViewController *)viewController {
    if (_viewController == viewController) {
        return;
    }
    
    [_viewController.view removeFromSuperview];
    [_viewController removeFromParentViewController];
    
    if (viewController) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        
        [self.scrollView addSubview:viewController.view];
        self.scrollView.contentSize = self.viewController.view.frame.size;
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *binding  = @{@"v" : viewController.view};
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:binding]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0]];
        
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:viewController.view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1
                                                              constant:-self.scrollView.parallaxHeader.minimumHeight];
        
        [self.scrollView addConstraint:self.heightConstraint];
    }
    _viewController = viewController;
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

#pragma mark MXSegmentedPagerControllerPageSegue class

@implementation MXScrollViewControllerSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[MXScrollViewController class]]) {
        MXScrollViewController *svc = self.sourceViewController;
        svc.viewController = self.destinationViewController;
    }
}

@end


