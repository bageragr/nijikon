//
//  ADBGroup.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "ADBGroup.h"
#define TABLE @"groups"

@implementation ADBGroup
- (id) init
{
    if (self = [super init])
    {
        [self setProperties:[NSDictionary dictionaryWithObjects: ADBGroupKeyArray forKeys: ADBGroupKeyArray]];
		
		nodeName = @"name";
    }
    return self;
}

- (void) dealloc
{
    [properties release];
    
    [super dealloc];
}

+ (ADBGroup*)groupWithProperties:(NSDictionary*)newProperties
{
	ADBGroup* temp = [[ADBGroup alloc] init];
	[temp setProperties:newProperties];
	return temp;
}

+ (ADBGroup*)groupWithQuickLiteRow:(QuickLiteRow*)row
{
	ADBGroup* temp = [[ADBGroup alloc] init];
	for (int i = 0; i < [[[temp properties] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp properties] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[temp properties] allKeys] objectAtIndex:i]]];
	return temp;
}

- (NSString*)description
{
	if ([[properties valueForKey:@"groupID"] isEqualToString:@"groupID"])
		return @"No such group";
	else
		return [properties valueForKey:nodeName];
}

- (NSMutableDictionary *) nodeProperties
{
	if (![[NSString stringWithFormat:@"G%@", [properties objectForKey:@"groupID"]] isEqualToString:[nodeProperties objectForKey:@"ID"]])
	{
		[nodeProperties setObject:[NSString stringWithFormat:@"G%@", [properties objectForKey:@"groupID"]] forKey:@"ID"];
		[nodeProperties setObject:[NSString stringWithFormat:@"%@", [properties objectForKey:nodeName]] forKey:@"name"];
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
@end
