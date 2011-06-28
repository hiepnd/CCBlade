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

#define POINT_LIMIT     50
#define USE_LAGRANGE    1
#define USE_STL_LIST    0

//#if USE_STL_LIST
//#include <list>
//using namespace std;
//#enif

inline float fangle(CGPoint vect);
inline float lagrange2(CGPoint p1, CGPoint p2, CGPoint p3, float x);
inline float lagrange1(CGPoint p1, CGPoint p2, float x);

inline void CGPointSet(CGPoint *v, float x, float y);
inline void f1(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2);
inline void f2(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2);

@interface CCBlade : CCNode {
#if USE_STL_LIST
	list<CGPoint> path;
#else
    NSMutableArray *path;
#endif
	unsigned int pointLimit;
	int count;
	CGPoint vertices[2*POINT_LIMIT + 5];
	CGPoint coordinates[2*POINT_LIMIT + 5];
	BOOL reset;
	@protected
	CCTexture2D *_texture;	
	float width;
}
@property unsigned int pointLimit;
@property(retain) CCTexture2D *texture;
@property float width;
- (void) push:(CGPoint) v;
- (void) pop;
- (void) clear;
- (void) reset;
- (void) dim:(BOOL) dim;
@end
