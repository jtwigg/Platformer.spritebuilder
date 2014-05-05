//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "PlayerController.h"
#import "CCDirector_Private.h"


@implementation MainScene

@synthesize controller;
@synthesize mushroomPhysicsNode = mushroomPhysicsNode;

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    [[CCDirector sharedDirector].scheduler scheduleTarget:self];
    
    
}

static const float kWorldCeiling = 200.0f;//Y coord;

-(void)update:(CCTime)delta
{
    CGPoint alienLocation = [controller.alienView convertToWorldSpaceAR:CGPointZero];
    alienLocation = [world convertToNodeSpace:alienLocation];
    
    float roof = fmaxf(kWorldCeiling, alienLocation.y);
    world.position= ccp(0.0f, kWorldCeiling - roof);
}


@end
