// MXScrollViewController.m
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

#import <objc/runtime.h>
#import "MXScrollViewController.h"

@interface MXScrollViewController ()
@property (nonatomic,weak) IBOutlet UIView *headerView;
@property (nonatomic) IBInspectable CGFloat headerHeight;
@property (nonatomic) IBInspectable CGFloat headerMinimumHeight;
@end

@implementation MXScrollViewController

static void * const kMXScrollViewControllerKVOContext = (void*)&kMXScrollViewControllerKVOContext;
@synthesize scrollView = _scrollView;

- (void)loadView {
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.parallaxHeader.view = self.headerView;
    self.scrollView.parallaxHeader.height = self.headerHeight;
    self.scrollView.parallaxHeader.minimumHeight = self.headerMinimumHeight;
    
    //Hack to perform segues on load
    @try {
        NSArray *templates = [self valueForKey:@"storyboardSegueTemplates"];
        for (id template in templates) {
            NSString *segueClasseName = [template valueForKey:@"_segueClassName"];
            if ([segueClasseName isEqualToString:NSStringFromClass(MXScrollViewControllerSegue.class)] ||
                [segueClasseName isEqualToString:NSStringFromClass(MXParallaxHeaderSegue.class)]) {
                NSString *identifier = [template valueForKey:@"identifier"];
                [self performSegueWithIdentifier:identifier sender:self];
            }
        }
    }
    @catch(NSException *exception) {}
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.scrollView.frame.size;
    [self layoutChildViewController];
}

- (void)layoutChildViewController {
    CGRect frame = self.scrollView.frame;
    frame.origin = CGPointZero;
    frame.size.height -= self.scrollView.parallaxHeader.minimumHeight;
    self.childViewController.view.frame = frame;
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

- (void)setHeaderViewController:(UIViewController *)headerViewController {
    if (_headerViewController.parentViewController == self) {
        [_headerViewController willMoveToParentViewController:nil];
        [_headerViewController.view removeFromSuperview];
        [_headerViewController removeFromParentViewController];
        [_headerViewController didMoveToParentViewController:nil];
    }
    
    if (headerViewController) {
        [headerViewController willMoveToParentViewController:self];
        [self addChildViewController:headerViewController];
        
        //Set parallaxHeader view
        objc_setAssociatedObject(headerViewController, @selector(parallaxHeader), self.scrollView.parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.scrollView.parallaxHeader.view = headerViewController.view;
        [headerViewController didMoveToParentViewController:self];
    }
    _headerViewController = headerViewController;
}

- (void)setChildViewController:(UIViewController<MXScrollViewDelegate> *)childViewController {
    if (_childViewController.parentViewController == self) {
        [_childViewController willMoveToParentViewController:nil];
        [_childViewController.view removeFromSuperview];
        [_childViewController removeFromParentViewController];
        [_childViewController didMoveToParentViewController:nil];
    }
    
    if (childViewController) {
        [childViewController willMoveToParentViewController:self];
        [self addChildViewController:childViewController];
        
        //Set UIViewController's parallaxHeader property
        objc_setAssociatedObject(childViewController, @selector(parallaxHeader), self.scrollView.parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.scrollView addSubview:childViewController.view];
        [childViewController didMoveToParentViewController:self];
    }
    _childViewController = childViewController;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kMXScrollViewControllerKVOContext) {
        
        if (self.childViewController && [keyPath isEqualToString:NSStringFromSelector(@selector(minimumHeight))]) {
            [self layoutChildViewController];
        }
    } else {
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

#pragma mark MXParallaxHeaderSegue class

@implementation MXParallaxHeaderSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[MXScrollViewController class]]) {
        MXScrollViewController *svc = self.sourceViewController;
        svc.headerViewController = self.destinationViewController;
    }
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


