//
//  WeemoContact.h
//  eXo Platform
//
//  Created by vietnq on 10/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeemoContact : NSObject <NSCoding>
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *displayName;
- (id)initWithUid:(NSString *)uid andDisplayName:(NSString *)displayName;
@end