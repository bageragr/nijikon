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
		
		nodeName = @"name";
    }
    return self;
}

- (void) dealloc
{
    [properties release];
    
    [super dealloc];
}

- (NSString*)description
{
	return [properties valueForKey:@"name"];
}

- (NSMutableDictionary *) nodeProperties
{
	if (![[NSString stringWithFormat:@"G%@", [properties objectForKey:@"groupID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"G%@", [properties objectForKey:@"groupID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:nodeName]] forKey:@"name"];
	}
    return nodeProperties;
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
