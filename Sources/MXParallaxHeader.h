// MXParallaxHeader.h
//
// Copyright (c) 2019 Maxime Epain
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

#import <UIKit/UIKit.h>
#import "MXScrollView.h"
#import "MXScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The parallac header mode.
 */
typedef NS_ENUM(NSInteger, MXParallaxHeaderMode) {
    /**
     The option to scale the content to fill the size of the header. Some portion of the content may be clipped to fill the header’s bounds.
     */
    MXParallaxHeaderModeFill = 0,
    /**
     The option to scale the content to fill the size of the header and aligned at the top in the header's bounds.
     */
    MXParallaxHeaderModeTopFill,
    /**
     The option to center the content aligned at the top in the header's bounds.
     */
    MXParallaxHeaderModeTop,
    /**
     The option to center the content in the header’s bounds, keeping the proportions the same.
     */
    MXParallaxHeaderModeCenter,
    /**
     The option to center the content aligned at the bottom in the header’s bounds.
     */
    MXParallaxHeaderModeBottom
};

@protocol MXParallaxHeaderDelegate;

/**
 The MXParallaxHeader class represents a parallax header for UIScrollView.
 */
@interface MXParallaxHeader : NSObject

/**
 The content view on top of the UIScrollView's content.
 */
@property (nonatomic,readonly) UIView *contentView;

/**
 Delegate instance that adopt the MXScrollViewDelegate.
 */
@property (nonatomic,weak,nullable) IBOutlet id<MXParallaxHeaderDelegate> delegate;

/**
 The header's view.
 */
@property (nonatomic,strong,nullable) IBOutlet UIView *view;

/**
 The header's default height. 0 by default.
 */
@property (nonatomic) IBInspectable CGFloat height;

/**
 The header's minimum height while scrolling up. 0 by default.
 */
@property (nonatomic) IBInspectable CGFloat minimumHeight;

/**
 The parallax header behavior mode.
 */
@property (nonatomic) MXParallaxHeaderMode mode;

/**
 The parallax header progress value.
 */
@property (nonatomic,readonly) CGFloat progress;

/**
 Loads a `view` from the nib file in the specified bundle.

 @param name The name of the nib file, without any leading path information.
 @param bundleOrNil The bundle in which to search for the nib file. If you specify nil, this method looks for the nib file in the main bundle.
 @param optionsOrNil A dictionary containing the options to use when opening the nib file. For a list of available keys for this dictionary, see NSBundle UIKit Additions.
 */
- (void)loadWithNibName:(NSString *)name bundle:(nullable NSBundle *)bundleOrNil options:(nullable NSDictionary<UINibOptionsKey, id> *)optionsOrNil;

@end

/**
 The method declared by the MXParallaxHeaderDelegate protocol allow the adopting delegate to respond to scoll from the MXParallaxHeader class.
 */
@protocol MXParallaxHeaderDelegate <NSObject>

@optional

/**
 Tells the header view that the parallax header did scroll.
 The view typically implements this method to obtain the change in progress from parallaxHeaderView.

 @param parallaxHeader The parallax header that scrolls.
 */
- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader;

@end

DEPRECATED_MSG_ATTRIBUTE("Use the MXParallaxHeader's delegate property instead.")
@protocol MXParallaxHeader <MXParallaxHeaderDelegate>
@end

/**
 A UIScrollView category with a MXParallaxHeader.
 */
@interface UIScrollView (MXParallaxHeader)

/**
 The parallax header.
 */
@property (nonatomic, strong) IBOutlet MXParallaxHeader *parallaxHeader;

@end

NS_ASSUME_NONNULL_END
