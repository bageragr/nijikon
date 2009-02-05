//
//  ADBGroup.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBGroup.h"


@implementation ADBGroup
- (id) init
{
    if (self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"groupID", @"rate", @"vts", @"animecount", @"filecount", @"name", @"short", @"ircchan", @"ircserv", @"url", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"groupID", @"rate", @"vts", @"animecount", @"filecount", @"name", @"short", @"ircchan", @"ircserv", @"url", nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
    }
    return self;
}

- (void) dealloc
{
    [properties release];
    
    [super dealloc];
}

- (NSMutableDictionary *) properties
{
    return properties;
}

- (void) setProperties: (NSDictionary *)newProperties
{
    if (properties != newProperties)
    {
        [properties autorelease];
        properties = [[NSMutableDictionary alloc] initWithDictionary: newProperties];
    }
}
@end
