//
//  TouchTrailLayer.m
//  ___PROJECTNAME___
//
//  Created by Ngo Duc Hiep on 4/28/11.
//  Copyright 2011 PTT Solution., JSC. All rights reserved.
//

#import "TouchTrailLayer.h"


@implementation TouchTrailLayer

- (id) init{
	self = [super init];
	isTouchEnabled_ = 1;
	
	return self;
}

- (void) ccTouchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = [CCBlade node];
		ws[touch] = w;
		w.texture = [[CCTextureCache sharedTextureCache] addImage:@"streak3.png"];
		[self addChild:w];
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesMoved:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = ws[touch];
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesEnded:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = ws[touch];
		[w dim:YES];
		ws.erase(touch);
	}
}
@end
