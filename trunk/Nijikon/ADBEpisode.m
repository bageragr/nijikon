//
//  KNEpisode.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "ADBEpisode.h"
#define TABLE @"episodes"

@implementation ADBEpisode
- (id) init
{
    if (self = [super init])
    {
        [self setProperties:[NSDictionary dictionaryWithObjects: ADBEpisodeKeyArray forKeys: ADBEpisodeKeyArray]];
		
		parents = [[NSMutableArray alloc] init];
		children = [[NSMutableArray alloc] init];
		
		nodeName = @"romaji";
    }
    return self;
}

- (void) dealloc
{
    [properties release];
	[parents release];
	[children release];
    
    [super dealloc];
}

+ (ADBEpisode*)episodeWithProperties:(NSDictionary*)newProperties andParents:(NSArray*)newParents
{
	ADBEpisode* temp = [[ADBEpisode alloc] init];
	[temp setProperties:newProperties];
	[temp setParents:newParents];
	return temp;
}

+ (ADBEpisode*)episodeWithQuickLiteRow:(QuickLiteRow*)row
{
	ADBEpisode* temp = [[ADBEpisode alloc] init];
	for (int i = 0; i < [[[temp properties] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp properties] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[temp properties] allKeys] objectAtIndex:i]]];
	return temp;
}

- (NSString*)description
{
	if ([[properties valueForKey:@"episodeID"] isEqualToString:@"episodeID"])
		return @"No such episode";
	else
		return [properties valueForKey:nodeName];
}

- (NSMutableDictionary*)nodeProperties
{
	if (![[NSString stringWithFormat:@"E%@", [properties objectForKey:@"episodeID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"E%@", [properties objectForKey:@"episodeID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSNumber numberWithInt:[[properties objectForKey:@"epnumber"] intValue]] forKey:@"number"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:nodeName]] forKey:@"name"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:@"epnumber"]] forKey:@"epnumber"];
		[nodeProperties setObject:[NSNumber numberWithInt:1] forKey:@"inMylistMax"];
		[nodeProperties setObject:[NSNumber numberWithInt:0] forKey:@"inMylistValue"];
	}
    return nodeProperties;
}

- (NSMutableDictionary *) properties
{
    return properties;
}

- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys
{
	[self setProperties:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
}

- (void) setProperties: (NSDictionary *)newProperties
{
    if (properties != newProperties)
    {
        [properties autorelease];
        properties = [[NSMutableDictionary alloc] initWithDictionary: newProperties];
    }
}

- (NSMutableArray*)parents
{
    return parents;
}

- (void)setParents:(NSArray*)newParents
{
    if (parents != newParents)
    {
        [parents autorelease];
        parents = [[NSMutableArray alloc] initWithArray:newParents];
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
        children = [[NSMutableArray alloc] initWithArray:newChildren];
    }
}
@end
