// MXScrollView.m
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

#import "MXScrollView.h"

@interface MXScrollViewDelegateForwarder : NSObject <MXScrollViewDelegate>
@property (nonatomic,weak) id<MXScrollViewDelegate> delegate;
@end

@interface MXScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MXScrollViewDelegateForwarder *delegateForwarder;
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *observedViews;
@end

@implementation MXScrollView {
    BOOL _isObserving;
    BOOL _lock;
}

static void * const kMXScrollViewKVOContext = (void*)&kMXScrollViewKVOContext;

@synthesize delegate = _delegate;
@synthesize bounces = _bounces;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    super.delegate = self.delegateForwarder;
    self.showsVerticalScrollIndicator = NO;
    self.directionalLockEnabled = YES;
    self.bounces = YES;
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:kMXScrollViewKVOContext];
    _isObserving = YES;
}

#pragma mark Properties

- (NSMutableArray *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableArray array];
    }
    return _observedViews;
}

- (MXScrollViewDelegateForwarder *)delegateForwarder {
    if (!_delegateForwarder) {
        _delegateForwarder = [MXScrollViewDelegateForwarder new];
    }
    return _delegateForwarder;
}

- (void)setDelegate:(id<MXScrollViewDelegate>)delegate {
    self.delegateForwarder.delegate = delegate;
    // Scroll view delegate caches whether the delegate responds to some of the delegate
    // methods, so we need to force it to re-evaluate if the delegate responds to them
    super.delegate = nil;
    super.delegate = self.delegateForwarder;
}

- (id<MXScrollViewDelegate>)delegate {
    return self.delegateForwarder.delegate;
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
        
        //Lock horizontal pan gesture.
        if (fabs(velocity.x) > fabs(velocity.y)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIScrollView *scrollView = (id)otherGestureRecognizer.view;
    
    BOOL shouldScroll = scrollView != self && [scrollView isKindOfClass:[UIScrollView class]];
    
    if (shouldScroll && [self.delegate respondsToSelector:@selector(scrollView:shouldScrollWithSubView:)]) {
        shouldScroll = [self.delegate scrollView:self shouldScrollWithSubView:scrollView];;
    }
    
    if (shouldScroll) {
        [self addObservedView:scrollView];
    }
    return shouldScroll;
}

#pragma mark KVO

- (void) addObserverToView:(UIScrollView *)scrollView {
    [scrollView addObserver:self
           forKeyPath:NSStringFromSelector(@selector(contentOffset))
              options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
              context:kMXScrollViewKVOContext];
    
    _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
}

- (void) removeObserverFromView:(UIScrollView *)scrollView {
    @try {
        [scrollView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(contentOffset))
                     context:kMXScrollViewKVOContext];
    }
    @catch (NSException *exception) {}
}

//This is where the magic happens...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        if (diff == 0.0 || !_isObserving) return;
        
        if (object == self) {
            
            //Adjust self scroll offset when scroll down
            if (diff > 0 && _lock) {
                [self scrollView:self setContentOffset:old];
            }
            else if (((self.contentOffset.y < -self.contentInset.top) && !self.bounces)) {
                [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentInset.top)];
            }
        }
        else {
            //Adjust the observed scrollview's content offset
            UIScrollView *scrollView = object;
            _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
            
            //Manage scroll up
            if (self.contentOffset.y < -self.parallaxHeader.minimumHeight && _lock && diff < 0) {
                [self scrollView:scrollView setContentOffset:old];
            }
            //Disable bouncing when scroll down
            if (!_lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces)) {
                [self scrollView:scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top)];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Scrolling views handlers

- (void) addObservedView:(UIScrollView *)scrollView {
    if (![self.observedViews containsObject:scrollView]) {
        [self.observedViews addObject:scrollView];
        [self addObserverToView:scrollView];
    }
}

- (void) removeObservedViews {
    for (UIScrollView *scrollView in self.observedViews) {
        [self removeObserverFromView:scrollView];
    }
    [self.observedViews removeAllObjects];
}

- (void) scrollView:(UIScrollView*)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kMXScrollViewKVOContext];
    [self removeObservedViews];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.contentOffset.y > -self.parallaxHeader.minimumHeight) {
        [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.parallaxHeader.minimumHeight)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _lock = NO;
    [self removeObservedViews];
}

@end

@implementation MXScrollViewDelegateForwarder

- (BOOL)respondsToSelector:(SEL)selector {
    return [self.delegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.delegate];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [(MXScrollView*)scrollView scrollViewDidScroll:scrollView];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(MXScrollView*)scrollView scrollViewDidEndDecelerating:scrollView];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end
