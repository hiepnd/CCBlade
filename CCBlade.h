//
//  CCBlade.h
//  1
//
//  Created by Ngo Duc Hiep on 4/21/11.
//  Copyright 2011 PTT Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include <list>

#define POINT_LIMIT 50
#define USE_LAGRANGE 1

using namespace std;

inline float lagrange2(CGPoint p1, CGPoint p2, CGPoint p3, float x);
inline float lagrange1(CGPoint p1, CGPoint p2, float x);

inline void CGPointSet(CGPoint *v, float x, float y);
inline void f1(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2);
inline void f2(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2);

@interface CCBlade : CCNode {
	list<CGPoint> path;
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
