//
//  ADBFile.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBFile.h"


@implementation ADBFile
- (id) init
{
    if (self = [super init])
    {
        [self setProperties:[NSDictionary dictionaryWithObjects: ADBEpisodeKeyArray forKeys: ADBEpisodeKeyArray]];
		
		nodeName = @"fileID";
    }
    return self;
}

- (void) dealloc
{
    [properties release];
	[self setGroup:nil];
    
    [super dealloc];
}

+ (ADBFile*)fileWithProperties:(NSDictionary*)newProperties
{
	ADBFile* temp = [[ADBFile alloc] init];
	[temp setProperties:newProperties];
	return temp;
}

- (NSString*)description
{
	if ([[properties valueForKey:@"fileID"] isEqualToString:@"fileID"])
		return @"No such file";
	else
		return [properties valueForKey:@"filename"];
}

- (NSMutableDictionary *) nodeProperties
{
	if (![[NSString stringWithFormat:@"F%@", [properties objectForKey:@"fileID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"F%@", [properties objectForKey:@"fileID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSString string] forKey:@"number"];
		[nodeProperties setObject:[NSString stringWithFormat:@"File \"%@\"", [properties objectForKey:nodeName]] forKey:@"name"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [nodeProperties objectForKey:@"name"]] forKey:@"epnumber"];
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
		
		[nodeProperties setObject:[properties objectForKey:@"fileID"] forKey:@"ID"];
		[nodeProperties setObject:[NSString stringWithFormat:@"File %@", [properties objectForKey:@"fileID"]] forKey:@"name"];
    }
}

- (ADBGroup*)group
{
	return group;
}

- (void)setGroup:(ADBGroup*)newGroup
{
	if (group != newGroup)
	{
		[group autorelease];
		group = [newGroup retain];
	}
}
@end
