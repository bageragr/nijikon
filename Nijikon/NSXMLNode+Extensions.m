//
//  NSXMLNode+Extensions.m
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSXMLNode+Extensions.h"


@implementation NSXMLNode(KNExtensions)

- (NSXMLNode *)childForName:(NSString *)name
{
	NSEnumerator *e = [[self children] objectEnumerator];
	
	NSXMLNode *node;
	while (node = [e nextObject]) 
		if ([[node name] isEqualToString:name])
			return node;
    
	return nil;
}

- (NSArray *)childrenAsStrings
{
	NSMutableArray *ret = [[NSMutableArray arrayWithCapacity:
							[[self children] count]] retain];
	NSEnumerator *e = [[self children] objectEnumerator];
	NSXMLNode *node;
	while (node = [e nextObject])
		[ret addObject:[node stringValue]];
	
	return [ret autorelease];
}
@end
