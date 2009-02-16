//
//  KNPreferences.m
//  Nijikon
//
//  Created by Pipelynx on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KNPreferences.h"


@implementation KNPreferences
- (id)init
{
	if ([super init]) {
		path = nil;
		document = nil;
		[self setProperties:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"", @"", nil]
														forKeys:KNPreferencesKeyArray]];
	}
	return self;
}

- (void)dealloc
{
	[properties release];
	[super dealloc];
}

+ (KNPreferences*)preferenceWithPath:(NSString*)absolutePath
{
	KNPreferences* temp = [[KNPreferences alloc] init];
	[temp setPath:absolutePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:absolutePath])
		[temp readPreferences];
	else
	{
		[temp populateDocument];
		[temp persistPreferences];
	}
	return temp;
}

- (void)populateDocument
{
	NSXMLElement* root = (NSXMLElement*)[NSXMLNode elementWithName:@"preferences"];
	for (int i = 0; i < [KNPreferencesKeyArray count]; i++)
		[root addChild:[NSXMLNode elementWithName:[KNPreferencesKeyArray objectAtIndex:i] stringValue:[properties valueForKey:[KNPreferencesKeyArray objectAtIndex:i]]]];
	document = [[NSXMLDocument alloc] initWithRootElement:root];
	[document setVersion:@"1.0"];
	[document setCharacterEncoding:@"UTF-8"];
}

- (void)readPreferences
{
	NSMutableDictionary* newProperties = [NSMutableDictionary dictionary];
	document = [[NSXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
	NSXMLElement* root = [document rootElement];
	for (int i = 0; i < [[root children] count]; i++)
		[newProperties setObject:[[[root children] objectAtIndex:i] stringValue] forKey:[[[root children] objectAtIndex:i] name]];
	[self setProperties:newProperties];
}

- (void)persistPreferences
{
	NSData* xmlData = [document XMLDataWithOptions:NSXMLNodePrettyPrint];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		[[NSFileManager defaultManager] createFileAtPath:path contents:xmlData attributes:nil];
	else
		[xmlData writeToFile:path atomically:YES];
}

- (NSString*)path
{
	return path;
}

- (void)setPath:(NSString*)newPath
{
	if (path != newPath)
	{
		[path release];
		path = [newPath retain];
	}
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
@end
