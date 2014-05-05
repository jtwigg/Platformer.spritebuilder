//
//  CCStateMachine.h
//  Platformer
//
//  Created by John Twigg on 4/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCState;
@class CCStateMachine;
@class CCEventMsg;

@protocol CCStateMachineDelegate <NSObject>
-(void)stateMachine:(CCStateMachine*)stateMachine entered:(CCState*)entered exited:(CCState*)exited msg:(CCEventMsg*)msg;
@end

@protocol CCStateProtocal <NSObject>

+(instancetype)stateWithContext:(id)context stateMachine:(CCStateMachine*)stateMachine;

@end

@interface CCStateMachine : NSObject
{
    id<CCStateMachineDelegate> delegate;

}

@property (nonatomic) CCState * currentState;
@property (nonatomic) NSMutableDictionary * states;
@property (nonatomic) id context;

//Suggest a course of action to the state machine.
-(void)receiveMessage:(CCEventMsg*)msg;

//Perform a state change. Returns TRUE is changed successfully.
-(BOOL)changeStateTo:(Class)targetState msg:(CCEventMsg*)msg;

-(void)update:(float)deltaTime;
@end

@interface CCState : NSObject <CCStateProtocal>
{
    CCStateMachine * stateMachine;
    id context;
}

-(id)initWithContext:(id)context stateMachine:(CCStateMachine*)stateMachine;

-(void)receiveMessage:(CCEventMsg*)msg;
-(BOOL)canEnterState:(CCState*)oldState msg:(CCEventMsg*)msg;
-(BOOL)canExitState:(CCState*)newState  msg:(CCEventMsg*)msg;

-(void)exitState:(CCEventMsg*)msg;
-(void)enterState:(CCEventMsg*)msg;
-(void)update:(float)deltaTime;

@end

@interface CCEventMsg : NSObject
{

}
@property (readonly) NSDictionary * data;



+(id)msgWithText:(NSString*)text;
+(id)msgWithDictionary:(NSDictionary*)dict;

-(id)initWithText:(NSString*)text;
-(id)initWithDictionary:(NSDictionary*)dict;

@end

