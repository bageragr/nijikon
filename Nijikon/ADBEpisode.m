//
//  KNEpisode.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBEpisode.h"


@implementation ADBEpisode
- (id) init
{
    if (self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
		
		children = [[NSMutableArray alloc] init];
		
		nodeName = @"romaji";
    }
    return self;
}

- (void) dealloc
{
    [properties release];
	[children release];
    
    [super dealloc];
}

- (NSString*)description
{
	if ([[properties valueForKey:@"episodeID"] isEqualToString:@"episodeID"])
		return @"No such episode";
	else
		return [properties valueForKey:nodeName];
}

- (NSMutableDictionary *) nodeProperties
{
	if (![[NSString stringWithFormat:@"E%@", [properties objectForKey:@"episodeID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"E%@", [properties objectForKey:@"episodeID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSNumber numberWithInt:[[properties objectForKey:@"epnumber"] intValue]] forKey:@"number"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:nodeName]] forKey:@"name"];
		[nodeProperties setObject:[NSNumber numberWithInt:1] forKey:@"inMylistMax"];
		[nodeProperties setObject:[NSNumber numberWithInt:0] forKey:@"inMylistValue"];
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
