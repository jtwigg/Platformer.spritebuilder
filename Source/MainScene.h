//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "PlayerController.h"

@class PlayerController;

@interface MainScene : CCNode
{
    CCPhysicsNode * mushroomPhysicsNode;
    CCNode * world;
}
@property PlayerController * controller;
@property CCPhysicsNode * mushroomPhysicsNode;

@end
