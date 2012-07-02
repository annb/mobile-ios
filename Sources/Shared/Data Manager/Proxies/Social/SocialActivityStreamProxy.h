//
//  SocialActivityStreamProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"
#import "SocialUserProfile.h"
#import "SocialActivity.h"

@class SocialUserProfileProxy;

@interface SocialActivityStreamProxy : SocialProxy {
    
    NSArray*                    _arrActivityStreams;
    
    BOOL                        _isUpdateRequest;
}

@property (nonatomic, retain) NSArray* arrActivityStreams;
@property (readonly) BOOL isUpdateRequest;

- (void)getActivityStreams;
- (void)updateActivityStreamSinceActivity:(SocialActivity *)activity;

@end


