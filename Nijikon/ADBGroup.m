//
//  ADBGroup.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBGroup.h"


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