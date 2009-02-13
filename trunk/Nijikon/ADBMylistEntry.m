//
//  ADBMylistEntry.m
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBMylistEntry.h"


@implementation ADBMylistEntry
- (id)init
{
	if (self = [super init])
    {
        NSArray* keys =		[NSArray arrayWithObjects:@"mylistID",@"fileID",@"episodeID",@"animeID",@"groupID",@"date",@"state",@"viewdate",@"storage",@"source",@"other",@"filestate",nil];
		NSArray* values =	[NSArray arrayWithObjects:@"mylistID",@"fileID",@"episodeID",@"animeID",@"groupID",@"date",@"state",@"viewdate",@"storage",@"source",@"other",@"filestate",nil];
        [self setProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
        
        children = [[NSMutableArray alloc] init];
		
		nodeName = @"mylistID";
    }
    return self;
}

- (void)dealloc
{
    [properties release];
    [children release];
    
    [super dealloc];
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
