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

@interface MXScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *observedViews;
@end

@implementation MXScrollView {
    BOOL _isObserving;
    BOOL _lock;
}

static void * const kMXScrollViewKVOContext = (void*)&kMXScrollViewKVOContext;

static NSString* const kContentOffsetKeyPath = @"contentOffset";

@synthesize delegate = _delegate;
@synthesize bounces = _bounces;

- (instancetype)init {
    self = [super init];
    if (self) {
        super.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.bounces = YES;
    }
    return self;
}

#pragma mark Properties

- (NSMutableArray *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableArray array];
    }
    return _observedViews;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    [super setScrollEnabled:scrollEnabled];
    
    if (scrollEnabled) {
        [self addObserver:self forKeyPath:kContentOffsetKeyPath
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:kMXScrollViewKVOContext];
    }
    else {
        @try {
            [self removeObserver:self forKeyPath:kContentOffsetKeyPath];
        }
        @catch (NSException *exception) {}
    }
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        MXPanGestureDirection direction = [(UIPanGestureRecognizer*)gestureRecognizer directionInView:self];
        
        //Lock horizontal pan gesture.
        if (direction == MXPanGestureDirectionLeft || direction == MXPanGestureDirectionRight) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL shouldScroll = YES;
    
    if ([self.delegate respondsToSelector:@selector(scrollView:shouldScrollWithSubView:)]) {
        shouldScroll = [self.delegate scrollView:self shouldScrollWithSubView:otherGestureRecognizer.view];;
    }
    
    if (shouldScroll) {
        [self addObservedView:otherGestureRecognizer.view];
    }
    return shouldScroll;
}

#pragma mark KVO

- (void) addObserverToView:(UIView *)view {
    _isObserving = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        [view addObserver:self
               forKeyPath:kContentOffsetKeyPath
                  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                  context:kMXScrollViewKVOContext];
    }
    _isObserving = YES;
}

- (void) removeObserverFromView:(UIView *)view {
    @try {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeObserver:self
                      forKeyPath:kContentOffsetKeyPath
                         context:kMXScrollViewKVOContext];
        }
    }
    @catch (NSException *exception) {}
}

//This is where the magic happens...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewKVOContext && [keyPath isEqualToString:kContentOffsetKeyPath]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        if (diff == 0 || !_isObserving) return;
        
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

- (void) addObservedView:(UIView *)view {
    if (![self.observedViews containsObject:view]) {
        [self.observedViews addObject:view];
        [self addObserverToView:view];
    }
}

- (void) removeObservedViews {
    for (UIView *view in self.observedViews) {
        [self removeObserverFromView:view];
    }
    [self.observedViews removeAllObjects];
}

- (void) scrollView:(UIScrollView*)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((self.contentOffset.y >= -self.parallaxHeader.minimumHeight)) {
        self.contentOffset = CGPointMake(self.contentOffset.x, -self.parallaxHeader.minimumHeight);
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _lock = NO;
    [self removeObservedViews];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}

@end

@implementation UIPanGestureRecognizer (Direction)

- (MXPanGestureDirection) directionInView:(UIView *)view {
    CGPoint velocity = [self velocityInView:view];
    CGFloat absX = fabs(velocity.x);
    CGFloat absY = fabs(velocity.y);
    
    if (absX > absY) {
        return (velocity.x > 0)? MXPanGestureDirectionRight : MXPanGestureDirectionLeft;
    }
    else if (absX < absY) {
        return (velocity.y > 0)? MXPanGestureDirectionDown : MXPanGestureDirectionUp;
    }
    return MXPanGestureDirectionNone;
}

@end
