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
		[self setAtt:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"~/Library/Application Support/Nijikon", @"nijikon.db", @"", @"", @"api.anidb.info", @"9000", @"19442", @"romaji", @"english", nil]
														forKeys:KNPreferencesKeyArray]];
	}
	return self;
}

- (void)dealloc
{
	[att release];
	[super dealloc];
}

- (NSString*)description {
	NSMutableString* description = [NSMutableString stringWithFormat:@"%@ {\n", [super description]];
	for (int i = 0; i < [att count]; i++)
		[description appendFormat:@"[%@]: %@\n", [[att allKeys] objectAtIndex:i], [[att allValues] objectAtIndex:i]];
	return [description stringByAppendingFormat:@"}"];
}

+ (KNPreferences*)preferenceWithPath:(NSString*)absolutePath
{
	KNPreferences* temp = [[KNPreferences alloc] init];
	[temp setPath:absolutePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:absolutePath])
		[temp readPreferences];
	else
		[temp persistPreferences];
	return temp;
}

- (void)populateDocument
{
	NSXMLElement* root = (NSXMLElement*)[NSXMLNode elementWithName:@"preferences"];
	for (int i = 0; i < [KNPreferencesKeyArray count]; i++)
		[root addChild:[NSXMLNode elementWithName:[KNPreferencesKeyArray objectAtIndex:i] stringValue:[att valueForKey:[KNPreferencesKeyArray objectAtIndex:i]]]];
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
	[self setAtt:newProperties];
}

- (void)persistPreferences
{
	[self populateDocument];
	[[NSFileManager defaultManager] removeFileAtPath:path handler:nil];
	[[NSFileManager defaultManager] createFileAtPath:path contents:[document XMLDataWithOptions:NSXMLNodePrettyPrint] attributes:nil];
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

- (NSMutableDictionary*)att
{
    return att;
}

- (void)setAtt:(NSDictionary*)newAtt
{
    if (att != newAtt)
    {
        [att autorelease];
        att = [[NSMutableDictionary alloc] initWithDictionary: newAtt];
    }
}
@end
