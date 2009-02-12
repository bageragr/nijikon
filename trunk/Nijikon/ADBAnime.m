//
//  KNAnime.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBAnime.h"


@implementation ADBAnime
- (id)init
{
	if (self = [super init])
    {
        NSArray* keys =		[NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",nil];
		NSArray* values =	[NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
        
        children = [[NSMutableArray alloc] init];
		
		nodeName = @"romaji";
    }
    return self;
}

- (void)dealloc
{
    [properties release];
    [children release];
    
    [super dealloc];
}

- (void)setValues:(NSArray*)values
{
	NSArray* keys =		[NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",nil];
	[self setProperties:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@ (%@ %@)", [properties valueForKey:nodeName], [properties valueForKey:@"type"], [properties valueForKey:@"year"]];
}

- (NSMutableDictionary*)nodeProperties
{
	if (![[NSString stringWithFormat:@"A%@", [properties objectForKey:@"animeID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"A%@", [properties objectForKey:@"animeID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSNumber numberWithInt:[[properties objectForKey:@"animeID"] intValue]] forKey:@"number"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:nodeName]] forKey:@"name"];
		[nodeProperties setObject:[NSNumber numberWithInt:[[properties objectForKey:@"allEps"] intValue]] forKey:@"inMylistMax"];
		[nodeProperties setObject:[NSNumber numberWithInt:[children count]] forKey:@"inMylistValue"];
	}
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
