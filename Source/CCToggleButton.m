//
//  CCToggleButton.m
//  Platformer
//
//  Created by John Twigg on 4/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCToggleButton.h"
@interface CCButton (Private)
- (void) stateChanged;
@end

@implementation CCToggleButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(self.block)
        self.block(self);
}

@end
