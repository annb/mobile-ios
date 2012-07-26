//
//  SocialPostActivity.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@interface SocialPostActivity : SocialProxy {
    
    NSString* _text;
}

@property (nonatomic,copy) NSString* text;

-(void)postActivity:(NSString *)message fileURL:(NSString*)fileURL fileName:(NSString*)fileName;

@end
