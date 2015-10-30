// MXRefreshHeaderView.m
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

#import "MXRefreshHeaderView.h"
#import "M13ProgressViewPie.h"

@interface MXRefreshHeaderView ()
@property (weak, nonatomic) IBOutlet M13ProgressViewPie *progressPie;

@end

@implementation MXRefreshHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

- (void)drawRect:(CGRect)rect {
    self.progressPie.primaryColor   = [UIColor orangeColor];
    self.progressPie.secondaryColor = [UIColor orangeColor];
}

#pragma mark Properties

- (CGFloat)progress {
    return self.progressPie.progress;
}

- (void)setProgress:(CGFloat)progress {
    if (!self.indeterminate) {
        // Show/Hide Progress
        self.progressPie.alpha = progress;
        
        [self.progressPie setProgress:progress animated:NO];
    }
}

- (BOOL)indeterminate {
    return self.progressPie.indeterminate;
}

- (void)setIndeterminate:(BOOL)indeterminate {
    if (indeterminate) {
        self.progress = 0;
    }

    self.progressPie.alpha = (indeterminate)? 1 : self.progress;
    self.progressPie.indeterminate = indeterminate;
}

@end
