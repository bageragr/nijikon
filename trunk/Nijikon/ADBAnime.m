//
//  KNAnime.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBAnime.h"


@implementation ADBAnime
- (BOOL)isLeaf
{
	return NO;
}

- (id) init
{
	if (self = [super init])
    {
        NSArray* keys =		[NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",nil];
		NSArray* values =	[NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
        
        children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [properties release];
    [children release];
    
    [super dealloc];
}

- (NSMutableDictionary *) nodeProperties
{
	[nodeProperties setObject:[properties objectForKey:@"animeID"] forKey:@"ID"];
	[nodeProperties setObject:[NSString stringWithFormat:@"%@ (\"%@\" - \"%@\")", [properties objectForKey:@"romaji"], [properties objectForKey:@"kanji"], [properties objectForKey:@"english"]] forKey:@"name"];
    return nodeProperties;
}

- (NSMutableDictionary*)properties
{
    return properties;
}

- (void)setProperties:(NSDictionary*)newProperties
{
    if (properties != newProperties)
    {
        [properties autorelease];
        properties = [[NSMutableDictionary alloc] initWithDictionary: newProperties];
    }
}

- (NSMutableArray*)children
{
    return children;
}

- (void)setChildren:(NSArray*)newChildren
{
    if (children != newChildren)
    {
        [children autorelease];
        children = [[NSMutableArray alloc] initWithArray: newChildren];
    }
}

@end
