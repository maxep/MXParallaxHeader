// MXParallaxHeader.m
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
#import "MXParallaxHeader.h"

@interface MXParallaxView : UIView
@property (nonatomic,weak) MXParallaxHeader *parent;
@end

@implementation MXParallaxView

static void * const kMXParallaxHeaderKVOContext = (void*)&kMXParallaxHeaderKVOContext;

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.superview removeObserver:self.parent forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kMXParallaxHeaderKVOContext];
}

- (void)didMoveToSuperview {
    [self.superview addObserver:self.parent
                     forKeyPath:NSStringFromSelector(@selector(contentOffset))
                        options:NSKeyValueObservingOptionNew
                        context:kMXParallaxHeaderKVOContext];
}

@end

@interface MXParallaxHeader ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end

@implementation MXParallaxHeader {
    BOOL _isObserving;
}

@synthesize contentView = _contentView;

#pragma mark Properties

- (UIView *)contentView {
    if (!_contentView) {
        MXParallaxView *contentView = [MXParallaxView new];
        contentView.parent = self;
        contentView.clipsToBounds = YES;
        _contentView = contentView;
    }
    return _contentView;
}

- (void)setView:(UIView *)view {
    if (view != _view) {
        _view = view;
        [self updateConstraints];
    }
}

- (void)setMode:(MXParallaxHeaderMode)mode {
    if (_mode != mode) {
        _mode = mode;
        [self updateConstraints];
    }
}

- (void)setHeight:(CGFloat)height {
    if (_height != height) {
        
        //Adjust content inset
        self.scrollViewContentTopInset = self.scrollView.contentInset.top - _height + height;
        
        _height = height;
        [self updateConstraints];
        [self layoutContentView];
    }
}

- (void)setMinimumHeight:(CGFloat)minimumHeight {
    _minimumHeight = minimumHeight;
    [self layoutContentView];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        
        //Adjust content inset
        self.scrollViewContentTopInset = self.scrollView.contentInset.top + self.height;
        
        //Layout content view
        [scrollView addSubview:self.contentView];
        [self layoutContentView];
        
        _isObserving = YES;
    }
}

- (CGFloat)progress {
    CGFloat x = self.height? (1/self.height) * self.contentView.frame.size.height : 1;
    return x - 1;
}

#pragma mark Constraints

- (void) updateConstraints {
    if (!self.view) {
        return;
    }
    
    [self.view removeFromSuperview];
    [self.contentView addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (self.mode) {
        case MXParallaxHeaderModeFill:
            [self setFillModeConstraints];
            break;
            
        case MXParallaxHeaderModeTop:
            [self setTopModeConstraints];
            break;
            
        case MXParallaxHeaderModeBottom:
            [self setBottomModeConstraints];
            break;
            
        default:
            [self setCenterModeConstraints];
            break;
    }
}

- (void) setCenterModeConstraints {
    
    NSDictionary *binding  = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.height]];
}

- (void) setFillModeConstraints {
    NSDictionary *binding  = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:binding]];
}

- (void) setTopModeConstraints {
    NSDictionary *binding  = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.height]];
}

- (void) setBottomModeConstraints {
    NSDictionary *binding  = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.height]];
}

#pragma mark Private Methods

- (void) layoutContentView {
    CGFloat minimumHeight = MIN(self.minimumHeight, self.height);
    CGFloat relativeYOffset = self.height - self.scrollView.contentOffset.y - self.scrollView.contentInset.top;
    
    self.contentView.frame = (CGRect){
        .origin.x       = 0,
        .origin.y       = -relativeYOffset,
        .size.width     = self.scrollView.frame.size.width,
        .size.height    = MAX(relativeYOffset, minimumHeight)
    };
}

- (void) setScrollViewContentTopInset:(CGFloat)top {
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    //Adjust content offset
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += inset.top - top;
    self.scrollView.contentOffset = offset;
    
    //Adjust content inset
    inset.top = top;
    self.scrollView.contentInset = inset;
}

#pragma mark KVO

//This is where the magic happens...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXParallaxHeaderKVOContext) {
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            [self layoutContentView];
            
            if ([self.view respondsToSelector:@selector(parallaxHeaderDidScroll:)]) {
                [(id<MXParallaxHeader>)self.view parallaxHeaderDidScroll:self];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@implementation UIScrollView (MXParallaxHeader)

- (MXParallaxHeader *)parallaxHeader {
    MXParallaxHeader *parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader) {
        parallaxHeader = [MXParallaxHeader new];
        parallaxHeader.scrollView = self;
        objc_setAssociatedObject(self, @selector(parallaxHeader), parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return parallaxHeader;
}

@end
