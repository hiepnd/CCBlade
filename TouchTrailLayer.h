//
//  TouchTrailLayer.h
//  ___PROJECTNAME___
//
//  Created by Ngo Duc Hiep on 4/28/11.
//  Copyright 2011 PTT Solution., JSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBlade.h"
#import <map>


using namespace std;

#define MAX_FINGERS 10

@interface TouchTrailLayer : CCLayer {
	//W *ws[MAX_FINGERS];
	//CFDictionaryRef touch;
	map<UITouch *,CCBlade *> ws;
}

@end
