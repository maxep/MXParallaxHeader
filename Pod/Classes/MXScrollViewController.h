//
//  MXScrollViewController.h
//  Pods
//
//  Created by Maxime Epain on 26/10/2015.
//
//

#import "MXScrollView.h"

@interface MXScrollViewController : UIViewController <MXScrollViewDelegate>

@property (nonatomic, strong, readonly, nonnull) MXScrollView *scrollView;

@property (nonatomic, strong, nullable) UIViewController *viewController;

@end

/**
 The MXPageSegue class creates a segue object to get pages from storyboard.
 */
@interface MXScrollViewControllerSegue : UIStoryboardSegue

@end
