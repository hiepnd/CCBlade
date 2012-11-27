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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define USE_LAGRANGE        1
#define USE_STL_LIST        0
#define USE_UPDATE_FOR_POP  1

inline float fangle(CGPoint vect);
inline float lagrange1(CGPoint p1, CGPoint p2, float x);

inline void CGPointSet(CGPoint *v, float x, float y);
inline void f1(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2);

@interface CCBlade : CCNode {
	int count;
	CGPoint *vertices;
	CGPoint *coordinates;
	BOOL reset;
    BOOL _finish;
    BOOL _willPop;
    
    float timeSinceLastPop;
    float popTimeInterval;
}
@property (readonly) unsigned int pointLimit;
@property(strong) CCTexture2D *texture;
@property(nonatomic) float width;
@property (nonatomic) BOOL autoDim;
@property(nonatomic,strong)NSMutableArray *path;

+ (id) bladeWithMaximumPoint:(int) limit;
- (id) initWithMaximumPoint:(int) limit;
- (void) push:(CGPoint) v;
- (void) pop:(int) n;
- (void) clear;
- (void) reset;
- (void) dim:(BOOL) dim;
- (void) finish;
@end
