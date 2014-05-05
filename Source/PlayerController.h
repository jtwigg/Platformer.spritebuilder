//
//  PlayerController.h
//  Platformer
//
//  Created by John Twigg on 4/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStateMachine.h"
#import "MainScene.h"

typedef enum
{
    eKeyboardState_None,
    eKeyboardState_Jump,
    eKeyboardState_Left,
    eKeyboardState_Right,
    
} eKeyboardState;


@interface PlayerController : NSObject <CCSchedulerTarget>
{
    CCNode * alienView;
    CCBAnimationManager * animationManager;
    CCStateMachine * stateMachine;
    eKeyboardState keyboardState;

}

@property (readonly) CCNode * alienView;
@property (readonly) CCBAnimationManager * animationManager;

-(id)initWithScene:(CCNode*)scene;
-(void)onKeyboardChange:(eKeyboardState)_keyboardState;
-(void)update:(CCTime)delta;
-(void)face:(bool)left;

@end
