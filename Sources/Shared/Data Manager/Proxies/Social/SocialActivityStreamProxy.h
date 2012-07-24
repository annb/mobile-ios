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

typedef enum {
  ActivityStreamProxyActivityTypeAllUpdates = 0,
  ActivityStreamProxyActivityTypeMyConnections, 
  ActivityStreamProxyActivityTypeMySpaces,
  ActivityStreamProxyActivityTypeMyStatus
} ActivityStreamProxyActivityType;

@class SocialUserProfileProxy;

@interface SocialActivityStreamProxy : SocialProxy {
    
    NSArray*                    _arrActivityStreams;
    
    BOOL                        _isUpdateRequest;
}

@property (nonatomic, retain) NSArray* arrActivityStreams;
@property (readonly) BOOL isUpdateRequest;
@property (nonatomic, retain) SocialUserProfile *userProfile;

- (void)getActivityStreams:(ActivityStreamProxyActivityType)activitytype;
- (void)updateActivityStreamSinceActivity:(SocialActivity *)activity;
- (NSString *)createPathForType:(ActivityStreamProxyActivityType)activityType;

@end


