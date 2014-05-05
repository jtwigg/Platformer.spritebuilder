//
//  CCStateMachine.m
//  Platformer
//
//  Created by John Twigg on 4/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCStateMachine.h"

@implementation CCStateMachine
@synthesize states;
@synthesize currentState;
@synthesize context;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        states = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(void)receiveMessage:(CCEventMsg *)msg
{
    [currentState receiveMessage:msg];
}

-(BOOL)changeStateTo:(Class)targetStateType msg:(CCEventMsg *)msg
{
    CCState * targetState = states[@((intptr_t)targetStateType)];
    if(targetState == nil)
    {   
        targetState = [(Class<CCStateProtocal>)targetStateType stateWithContext:context stateMachine:self];

        states[@((intptr_t)targetStateType)] = targetState;
    }
    
    if(![targetState canEnterState:currentState msg:msg])
    {
        return NO;
    }
    
    if(currentState && ![currentState canExitState:targetState msg:msg])
    {
        return NO;
    }
    
    [currentState exitState:msg];
    currentState = targetState;
    
    [targetState enterState:msg];
    return YES;
}

-(void)update:(float)deltaTime
{
    [currentState update:deltaTime];
}

@end


@implementation CCState

+(instancetype)stateWithContext:(id)_context stateMachine:(CCStateMachine*)stateMachine
{
    return [[self alloc] initWithContext:_context stateMachine:stateMachine];
}

-(id)initWithContext:(id)_context stateMachine:(CCStateMachine*)_stateMachine
{
    self = [super init];
    if(self)
    {
        context = _context;
        stateMachine = _stateMachine;
    }
    
    return self;
}

-(void)receiveMessage:(CCEventMsg*)msg
{
    
}

-(BOOL)canEnterState:(CCState*)oldState msg:(CCEventMsg*)msg
{
    return YES;
}
-(BOOL)canExitState:(CCState*)newState  msg:(CCEventMsg*)msg
{
    return YES;
}

-(void)exitState:(CCEventMsg*)msg
{

}

-(void)enterState:(CCEventMsg*)msg
{

}

-(void)update:(float)deltaTime
{

}

@end

@implementation CCEventMsg
@synthesize data;


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        data = dict;
    }
    return self;
}

-(id)initWithText:(NSString *)text
{
    return [self initWithDictionary:@{@"type":text}];
}

-(NSString*)description
{
    return data[@"type"];
}

+(id)msgWithDictionary:(NSDictionary*)dict;
{
    return [[CCEventMsg alloc] initWithDictionary:dict];
}

+(id)msgWithText:(NSString *)text
{
    return [[CCEventMsg alloc] initWithText:text];
}



@end