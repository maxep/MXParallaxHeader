//
//  MXFalconHeader.m
//  MXParallaxHeader
//
//  Created by Maxime Epain on 11/12/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXFalconHeader.h"
#import "MXParallaxHeader.h"

@interface MXFalconHeader () <MXParallaxHeader>
@property (weak, nonatomic) IBOutlet UIImageView *falcon;
@end

@implementation MXFalconHeader

+ (MXFalconHeader *)instanciateFromNib {
    return [NSBundle.mainBundle loadNibNamed:@"FalconHeader" owner:self options:nil].firstObject;
}


#pragma mark <MXParallaxHeader>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    CGFloat angle = parallaxHeader.progress * M_PI * 2;
    self.falcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
}

@end
