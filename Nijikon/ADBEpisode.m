//
//  KNEpisode.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBEpisode.h"


@implementation ADBEpisode
- (BOOL)isLeaf
{
	return NO;
}

- (id) init
{
    if (self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
    }
    return self;
}

- (void) dealloc
{
    [properties release];
    
    [super dealloc];
}

- (NSMutableDictionary *) nodeProperties
{
	if (![[properties objectForKey:@"episodeID"] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[properties objectForKey:@"episodeID"] forKey:@"ID"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@ (\"%@\" - \"%@\")", [properties objectForKey:@"romaji"], [properties objectForKey:@"kanji"], [properties objectForKey:@"english"]] forKey:@"name"];
		NSLog(@"ID: %@", [nodeProperties objectForKey:@"ID"]);
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

- (NSMutableArray *) children
{
    return children;
}

- (void) setChildren: (NSArray *)newChildren
{
    if (children != newChildren)
    {
        [children autorelease];
        children = [[NSMutableArray alloc] initWithArray: newChildren];
    }
}
@end
