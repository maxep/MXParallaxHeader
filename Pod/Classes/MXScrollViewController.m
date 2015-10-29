//
//  MXScrollViewController.m
//  Pods
//
//  Created by Maxime Epain on 26/10/2015.
//
//

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


