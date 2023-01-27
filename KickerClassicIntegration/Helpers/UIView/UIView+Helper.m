//
//  UIView+Helper.m
//  KickerClassicIntegration
//
//  Created by Roman Slyepko on 27.01.2023.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)removeAllSubviews {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

@end
