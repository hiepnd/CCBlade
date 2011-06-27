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
    map = CFDictionaryCreateMutable(NULL,0,NULL,NULL);
	return self;
}

- (void) ccTouchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = [CCBlade node];
        int rand = arc4random() % 3 + 1;
		w.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"streak%d.png",rand]];
        
        CFDictionaryAddValue(map,touch,w);
        
		[self addChild:w];
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesMoved:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = (CCBlade *)CFDictionaryGetValue(map, touch);
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesEnded:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = (CCBlade *)CFDictionaryGetValue(map, touch);
		[w dim:YES];
        CFDictionaryRemoveValue(map,touch);
	}
}

- (void) dealloc{
    CFRelease(map);
    [super dealloc];
}
@end
