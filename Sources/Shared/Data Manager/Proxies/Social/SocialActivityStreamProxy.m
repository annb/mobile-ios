//
//  SocialActivityStreamProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStreamProxy.h"
#import "SocialIdentity.h"
#import "SocialRestConfiguration.h"
#import "SocialActivityStream.h"
#import "SocialUserProfileProxy.h"


@implementation SocialActivityStreamProxy

@synthesize socialUserProfile = _socialUserProfile;
@synthesize arrActivityStreams = _arrActivityStreams;
@synthesize isUpdateRequest = _isUpdateRequest;


- (id)initWithSocialUserProfile:(SocialUserProfile*)aSocialUserProfile
{
    if ((self = [super init])) 
    { 
        _socialUserProfile = [aSocialUserProfile retain];
        _isUpdateRequest = NO;
    } 
    return self;
}

- (void)dealloc 
{
    
    [_socialUserProfile release]; _socialUserProfile = nil;
    [_arrActivityStreams release]; _arrActivityStreams = nil;
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL 
{
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity_stream/",socialConfig.domainName,socialConfig.restContextName,socialConfig.restVersion,socialConfig.portalContainerName];

}



//Helper to create the path to get the ressources
- (NSString *)createPath 
{    
    NSLog(@"%@", [NSString stringWithFormat:@"%@/user/default.json",_socialUserProfile.identity]);
    
    return [NSString stringWithFormat:@"%@/feed/default.json",_socialUserProfile.identity]; 
}


#pragma mark - Call methods

- (void) getActivityStreams 
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivityStream class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"liked",@"liked",
     @"postedTime",@"postedTime",            
     @"type",@"type",
     @"posterIdentity",@"posterIdentity",
     @"activityStream",@"activityStream",
     @"id",@"activityId",
     @"title",@"title",
     @"priority",@"priority",
     @"createdAt",@"createdAt",
     @"likedByIdentities",@"likedByIdentities",
     @"titleId",@"titleId",
     @"comments",@"comments", 
    nil];
    
    [manager.mappingProvider setObjectMapping:mapping forKeyPath:@"activities"];
    
    //[manager registerClass:[SocialActivityStream class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[self createPath] delegate:self];   
}

- (void)updateActivityStreamSinceActivity:(SocialActivityStream*)activity {

    _isUpdateRequest = YES;
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivityStream class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"liked",@"liked",
     @"postedTime",@"postedTime",            
     @"type",@"type",
     @"posterIdentity",@"posterIdentity",
     @"activityStream",@"activityStream",
     @"id",@"activityId",
     @"title",@"title",
     @"priority",@"priority",
     @"createdAt",@"createdAt",
     @"likedByIdentities",@"likedByIdentities",
     @"titleId",@"titleId",
     @"comments",@"comments", 
     nil];
    
    [manager.mappingProvider setObjectMapping:mapping forKeyPath:@"activities"];
    
    //[manager registerClass:[SocialActivityStream class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@/feed/newer/%@.json",_socialUserProfile.identity,activity.activityId] delegate:self]; 
    
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
//	NSLog(@"Loaded statuses: %@", objects);    
    _arrActivityStreams = [objects retain];
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
    if (delegate && [delegate respondsToSelector:@selector(proxy: didFailWithError:)]) {
        [delegate proxy:self didFailWithError:error];
    }
}

 
@end
