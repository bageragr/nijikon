//
//  KNAnime.m
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "ADBAnime.h"
#define TABLE @"anime"

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
	NSArray* commaSeparated = [NSArray arrayWithObjects:@"categList", @"categWeightList", @"categIDList", nil];
	for (int i = 0; i < [commaSeparated count]; i++)
		[[temp properties] setValue:[[newProperties valueForKey:[commaSeparated objectAtIndex:i]] componentsSeparatedByString:@","] forKey:[commaSeparated objectAtIndex:i]];
	NSArray* apostropheSeparated = [NSArray arrayWithObjects:@"relList", @"relType", @"others", @"shortNames", @"synonyms", @"prodNameList", @"prodIDList", nil];
	for (int i = 0; i < [apostropheSeparated count]; i++)
		[[temp properties] setValue:[[newProperties valueForKey:[apostropheSeparated objectAtIndex:i]] componentsSeparatedByString:@"'"] forKey:[apostropheSeparated objectAtIndex:i]];
	return temp;
}

+ (ADBAnime*)animeWithQuickLiteRow:(QuickLiteRow*)row
{
	ADBAnime* temp = [[ADBAnime alloc] init];
	for (int i = 0; i < [[[temp properties] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp properties] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[temp properties] allKeys] objectAtIndex:i]]];
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database
{
	[database insertValues:[[NSArray arrayWithObject:[NSNull null]] arrayByAddingObjectsFromArray:[properties allValues]]
			   forColumns:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:[properties allKeys]] inTable:TABLE];
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
