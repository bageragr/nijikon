//
//  ADBFile.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBFile.h"


@implementation ADBFile
- (BOOL)isLeaf
{
	return YES;
}

- (id) init
{
    if (self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"fileID", @"animeID", @"episodeID", @"groupID", @"state", @"size", @"ed2k", @"filename", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"fileID", @"animeID", @"episodeID", @"groupID", @"state", @"size", @"ed2k", @"filename", nil];
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
		
		[nodeProperties setObject:[properties objectForKey:@"fileID"] forKey:@"ID"];
		[nodeProperties setObject:@"" forKey:@"name"];
    }
}
@end
