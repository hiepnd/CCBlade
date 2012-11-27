/*
 * cocos2d+ext for iPhone
 *
 * Copyright (c) 2011 - Ngo Duc Hiep
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "TouchTrailLayer.h"

@implementation TouchTrailLayer

- (id) init{
	self = [super init];
	isTouchEnabled_ = 1;
    map = CFDictionaryCreateMutable(NULL,0,NULL,NULL);
    CCSprite *bg = [CCSprite spriteWithFile:@"Default.png"];
    bg.rotation = 90;
    bg.position = ccp(240,160);
    [self addChild:bg];
    
	return self;
}

+ (CCScene *) scene{
    CCScene *scene = [CCScene node];
    [scene addChild:[self node]];
    return scene;
}

- (void) ccTouchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = [CCBlade bladeWithMaximumPoint:50];
        w.autoDim = YES;
        int rand = arc4random() % 3 + 1;
		w.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"streak%d.png",rand]];
        
        CFDictionaryAddValue(map,(__bridge const void *)(touch),(__bridge void*)w);
        
		[self addChild:w];
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesMoved:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = (CCBlade *)CFDictionaryGetValue(map, (__bridge const void *)(touch));
		CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
		[w push:pos];
	}
}

- (void) ccTouchesEnded:(NSSet *) touches withEvent:(UIEvent *) event{
	for (UITouch *touch in touches) {
		CCBlade *w = (CCBlade *)CFDictionaryGetValue(map, (__bridge const void *)(touch));
        [w finish];
        CFDictionaryRemoveValue(map,(__bridge const void *)(touch));
	}
}

- (void) dealloc{
    CFRelease(map);
}
@end
