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
        [self setProperties:[NSDictionary dictionaryWithObjects: ADBAnimeKeyArray forKeys: ADBAnimeKeyArray]];
        
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

+ (ADBAnime*)animeWithProperties:(NSDictionary*)newProperties
{
	ADBAnime* temp = [[ADBAnime alloc] init];
	[temp setProperties:newProperties];
	return temp;
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
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [nodeProperties objectForKey:@"name"]] forKey:@"epnumber"];
		[nodeProperties setObject:[NSNumber numberWithInt:[[properties objectForKey:@"nEps"] intValue]] forKey:@"inMylistMax"];
		[nodeProperties setObject:[NSNumber numberWithInt:[children count]] forKey:@"inMylistValue"];
	}
    return nodeProperties;
}

- (NSMutableDictionary*)properties
{
    return properties;
}

- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys
{
	[self setProperties:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
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
