//
//  SocialRestConfiguration.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialRestConfiguration.h"
#import "defines.h"


@implementation SocialRestConfiguration

@synthesize domainName = _domainName;
@synthesize domainNameWithCredentials = _domainNameWithCredentials;
@synthesize restVersion =  _restVersion;
@synthesize restContextName = _restContextName;
@synthesize portalContainerName = _portalContainerName;
@synthesize username = _username;
@synthesize password = _password;



#pragma Object Management

+ (SocialRestConfiguration*)sharedInstance
{
	static SocialRestConfiguration *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[SocialRestConfiguration alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}


- (id) init
{
    if ((self = [super init])) 
    {
        _domainName = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] copy];
        _restContextName = [kRestContextName copy];
        _restVersion = [kRestVersion copy];
        _portalContainerName = [kPortalContainerName copy];
        _username = [(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME] copy];
        _password = [(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_PASSWORD] copy];
        
        //TODO SLM
        //REmove this line and provide a true Server URL analyzer
        NSString *domainWithoutHttp = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] stringByReplacingOccurrencesOfString:@"http://" 
                                                                                                                                            withString:@""];
        
        //TODO SLM
        //REmove this line and provide a true Server URL analyzer
        domainWithoutHttp = [domainWithoutHttp stringByReplacingOccurrencesOfString:@"/portal" withString:@""];
        _domainNameWithCredentials = [[NSString alloc] initWithFormat:@"http://%@:%@%@%@",
                                      (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME],
                                      (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_PASSWORD],
                                      @"@",
                                      domainWithoutHttp];
        
    }	
	return self;
}

- (void) dealloc
{
	[_domainName release];
    [_domainNameWithCredentials release];
    [_portalContainerName release];
    [_restContextName release];
    [_restVersion release];
    [_username release];
    [_password release];
	[super dealloc];
}




@end
