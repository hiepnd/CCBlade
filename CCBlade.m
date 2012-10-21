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

#import "CCBlade.h"

inline float fangle(CGPoint vect){
	if (vect.x == 0.0 && vect.y == 0.0) {
		return 0;
	}
	
	if (vect.x == 0.0) {
		return vect.y > 0 ? M_PI/2 : -M_PI/2;
	}
	
	if (vect.y == 0.0 && vect.x < 0) {
		return -M_PI;
	}
	
	float angle = atan(vect.y / vect.x);
    
	return vect.x < 0 ? angle + M_PI : angle;
}

inline void f1(CGPoint p1, CGPoint p2, float d, CGPoint *o1, CGPoint *o2){
	float l = ccpDistance(p1, p2);
	float angle = fangle(ccpSub(p2, p1));
	*o1 = ccpRotateByAngle(ccp(p1.x + l,p1.y + d), p1, angle);
	*o2 = ccpRotateByAngle(ccp(p1.x + l,p1.y - d), p1, angle);
}

inline float lagrange1(CGPoint p1, CGPoint p2, float x){
	return (x-p1.x)/(p2.x - p1.x)*p2.y + (x-p2.x)/(p1.x - p2.x)*p1.y ;
}

inline void CGPointSet(CGPoint *v, float x, float y){
	v->x = x;
	v->y = y;
}

@implementation CCBlade

+ (id) bladeWithMaximumPoint:(int) limit{
    return [[self alloc] initWithMaximumPoint:limit];    
}

#define POP_TIME_INTERVAL 1./60.

- (id) initWithMaximumPoint:(int) limit{
    self = [super init];
    
    _pointLimit = limit;
	_width = 5;
	
    vertices = (CGPoint *)calloc(2*limit+5, sizeof(vertices[0]));
    coordinates = (CGPoint *)calloc(2*limit+5, sizeof(coordinates[0]));
    
    CGPointSet(coordinates+0, 0.00, 0.5);
    reset = NO;
    
    _path = [[NSMutableArray alloc] init];
    
#if USE_UPDATE_FOR_POP
    popTimeInterval = POP_TIME_INTERVAL;
    
    timeSinceLastPop = 0;
    [self scheduleUpdateWithPriority:0];
#endif
    
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
    
    return self;
}

- (void) dealloc{
    free(vertices);
    free(coordinates);
    
}

- (void) populateVertices{
    vertices[0] = [[_path objectAtIndex:0] CGPointValue];
    CGPoint pre = vertices[0];
    
    unsigned int i = 0;
    CGPoint it = [[_path objectAtIndex:1] CGPointValue];
	float dd = _width / [_path count];
	while (i < [_path count] - 2){
		f1(pre, it, _width - i * dd , vertices+2*i+1, vertices+2*i+2);
		CGPointSet(coordinates+2*i+1, .5, 1.0);
		CGPointSet(coordinates+2*i+2, .5, 0.0);
		
		i++;
		pre = it;
		
		it = [[_path objectAtIndex:i+1] CGPointValue];
	}
    
    CGPointSet(coordinates+1, 0.25, 1.0);
	CGPointSet(coordinates+2, 0.25, 0.0);
	
	vertices[2*[_path count]-3] = it;
	CGPointSet(coordinates+2*[_path count]-3, 0.75, 0.5);
}

- (void) shift{
	int index = 2 * _pointLimit - 1;
	for (int i = index; i > 3; i -= 2) {
		vertices[i] = vertices[i-2];
		vertices[i-1] = vertices[i-3];
	}
}

- (void) set_width:(float)newWidth{
    _width = newWidth ;//* CC_CONTENT_SCALE_FACTOR();
}

#define DISTANCE_TO_INTERPOLATE 10

- (void) push:(CGPoint) v{
    _willPop = NO;
    
	if (reset) {
		return;
	}
    
#if USE_LAGRANGE
    
    if ([_path count] == 0) {
        [_path insertObject:[NSValue valueWithCGPoint:v] atIndex:0];
        return;
    }
    
    CGPoint first = [[_path objectAtIndex:0] CGPointValue];
    if (ccpDistance(v, first) < DISTANCE_TO_INTERPOLATE) {
        [_path insertObject:[NSValue valueWithCGPoint:v] atIndex:0];
        if ([_path count] > _pointLimit) {
            [_path removeLastObject];
        }
    }else{
        int num = ccpDistance(v, first) / DISTANCE_TO_INTERPOLATE;
        CGPoint iv = ccpMult(ccpSub(v, first), (float)1./(num + 1));
		for (int i = 1; i <= num + 1; i++) {
            [_path insertObject:[NSValue valueWithCGPoint:ccpAdd(first, ccpMult(iv, i))] atIndex:0];
		}
		while ([_path count] > _pointLimit) {
			[_path removeLastObject];
		}
    }
#else // !USE_LAGRANGE
	_path.push_front(v);
	if (_path.size() > pointLimit) {
		_path.pop_back();
	}
#endif // !USE_LAGRANGE
    
	
	[self populateVertices];
}

- (void) pop:(int) n{
    while ([_path count] > 0 && n > 0) {
        [_path removeLastObject];
        n--;
    }
    
    if ([_path count] > 2) {
        [self populateVertices];
    }
}

- (void) clear{
    [_path removeAllObjects];
	reset = NO;
    if (_finish)
        [self removeFromParentAndCleanup:YES];
}

- (void) reset{
	reset = TRUE;
}

- (void) dim:(BOOL) dim{
	reset = dim;
}

- (void) update:(ccTime)dt {
    
    timeSinceLastPop += dt;
    
    float precision = 1./60.;
    float roundedTimeSinceLastPop = precision * roundf(timeSinceLastPop/precision); // helps because fps flucuate around 1./60.
    
    int numberOfPops = (int)  (roundedTimeSinceLastPop/popTimeInterval) ;
    timeSinceLastPop = timeSinceLastPop - numberOfPops * popTimeInterval;
    
    for (int pop = 0; pop < numberOfPops; pop++) {
        
        if ((reset && [_path count] > 0) || (self.autoDim && _willPop)) {
            [self pop:1];
            if ([_path count] < 3) {
                [self clear];
                if (_finish) {
                    return; // if we continue self will have been deallocated
                }
            }
        }
        
    }
}

- (void) draw{
    
#if !USE_UPDATE_FOR_POP
    if ((reset && [_path count] > 0) || (self.autoDim && _willPop)) {
        [self pop:1];
        if ([_path count] < 3) {
            [self clear];
            if (_finish) {
                return; // if we continue self will have been deallocated
            }
        }
    }
#endif
    
    if(_path == nil)
        return;
    
    if ([_path count] < 3) {
        return;
    }
    
    _willPop = YES;
    CC_NODE_DRAW_SETUP();
	ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position |  kCCVertexAttribFlag_TexCoords);
    
    ccGLBindTexture2D( [_texture name] );
    ccGLBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, coordinates);
    
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 2*[_path count]-2);
	
    CC_INCREMENT_GL_DRAWS(1);
}

- (void) finish
{
    _finish = YES;
}

@end
