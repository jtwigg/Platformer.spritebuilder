//
//  PlayerController.m
//  Platformer
//
//  Created by John Twigg on 4/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlayerController.h"
#import "CCDirector_Private.h"

@class PlayerStateStanding;

@interface PlayerState : CCState
@property (readonly) PlayerController * controller;
@end

@interface PlayerStateStanding : PlayerState

@end


@interface PlayerStateJumping: PlayerState
{
    float timeInAir;
}
@end


@interface PlayerStateWalking : PlayerState
{
    
}
@end

@interface PlayerStateFalling : PlayerState

@end

@implementation PlayerState
-(PlayerController*)controller
{
    return context;
}
@end

@implementation PlayerStateJumping

-(void)enterState:(CCEventMsg *)msg
{
    [self.controller.alienView.physicsBody applyImpulse:ccp(0.0f,1300.0f)];
    timeInAir = 0.0f;
    [stateMachine changeStateTo:[PlayerStateFalling class] msg:nil];
    
}


@end



@implementation PlayerStateWalking
-(void)enterState:(CCEventMsg*)msg
{
    [self.controller.animationManager runAnimationsForSequenceNamed:@"Walk"];
    if([msg.description isEqualToString:@"walk"])
    {
        [self.controller face: [msg.data[@"direction"] boolValue]];
    }
}

-(void)update:(float)deltaTime
{
    [super update:deltaTime];
    
    float sign =self.controller.alienView.scaleX;
    [self.controller.alienView.physicsBody setForce:ccp(sign * 1000.0f,0.0f)];
    
}

-(void)receiveMessage:(CCEventMsg *)msg
{
    if([msg.description isEqualToString:@"stop"])
    {
        [stateMachine changeStateTo:[PlayerStateStanding class] msg:nil];
    }
    
}
@end


@implementation PlayerStateFalling


-(void)enterState:(CCEventMsg *)msg
{
    [self.controller.animationManager runAnimationsForSequenceNamed:@"Falling"];
}

-(void)receiveMessage:(CCEventMsg *)msg
{
    if([msg.description isEqualToString:@"falling"])
    {
        if([msg.data[@"isColliding"] boolValue])
        {
            [stateMachine changeStateTo:[PlayerStateStanding class] msg:nil];
            return;
        }
    }
    
    if([msg.description isEqualToString:@"walk"])
    {
       [self.controller face: [msg.data[@"direction"] boolValue]];
        float sign =self.controller.alienView.scaleX;
        [self.controller.alienView.physicsBody setForce:ccp(sign * 1000.0f,0.0f)];
    }
    
}

@end



@implementation PlayerStateStanding
-(void)enterState:(CCEventMsg *)msg
{
     [self.controller.animationManager runAnimationsForSequenceNamed:@"Stand"];
}

-(void)receiveMessage:(CCEventMsg *)msg
{
    if([msg.description isEqualToString:@"jump"])
    {
         [stateMachine changeStateTo:[PlayerStateJumping class] msg:msg];
    }

    if([msg.description rangeOfString:@"walk"].length > 0)
    {
         [stateMachine changeStateTo:[PlayerStateWalking class] msg:msg];
    }
    
    if([msg.description isEqualToString:@"falling"])
    {
        if(![msg.data[@"isColliding"] boolValue])
        {
            [stateMachine changeStateTo:[PlayerStateFalling class] msg:nil];
            return;
        }
    }

}

@end


    
@implementation PlayerController
@synthesize priority;
@synthesize alienView = alienView;
@synthesize animationManager = animationManager;

-(id)initWithScene:(MainScene*)scene;
{
    self = [super init];
    if(self)
    {
        alienView = [CCBReader load:@"Alien" owner:self];
        animationManager = alienView.userObject;
        stateMachine = [[CCStateMachine alloc] init];
        stateMachine.context = self;

        [stateMachine changeStateTo:[PlayerStateStanding class] msg:nil];
        [[[CCDirector sharedDirector] scheduler] scheduleTarget:self];
        [[[CCDirector sharedDirector] scheduler] setPaused:NO target:self];
        
        [scene.mushroomPhysicsNode addChild:alienView];
        alienView.position = ccp(100,170);
    }
    
    return self;
    
}

-(void)face:(bool)left
{
    if(left)
    {
        alienView.scaleX = -1.0f;
    }
    else
    {
        alienView.scaleX = 1.0f;
    }
}

-(void)onKeyboardChange:(eKeyboardState)_keyboardState
{

    keyboardState = _keyboardState;
   }

-(void)update:(CCTime)delta
{
    __block BOOL isColliding = NO;
    [alienView.physicsBody eachCollisionPair:^(CCPhysicsCollisionPair *pair) {

        if(ccpDot(pair.contacts.normal,ccp(0.0f,1.0f)) < -0.8)
        {
            isColliding = YES;
        }
    }];

    [stateMachine receiveMessage:[CCEventMsg msgWithDictionary:@{@"type" : @"falling",
                                                                 @"isColliding":@(isColliding)}]];
    
    switch (keyboardState) {
        case eKeyboardState_Jump:
            [stateMachine receiveMessage:[CCEventMsg msgWithText:@"jump"]];
            break;
        case eKeyboardState_Left:
        case eKeyboardState_Right:
            {
                NSDictionary * dict = @{@"type" : @"walk", @"direction" : @(keyboardState == eKeyboardState_Left ? 1 : 0)};
                CCEventMsg * msg = [CCEventMsg msgWithDictionary:dict];
                [stateMachine receiveMessage:msg];
            }
            break;
        default:
            [stateMachine receiveMessage:[CCEventMsg msgWithText:@"stop"]];
            break;
    }

    
    [stateMachine update:delta];
}

-(void)onAnimCBJump
{
    
}

@end
