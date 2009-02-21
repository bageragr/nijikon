//
//  ADBMylistExport.m
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBMylistExport.h"


@implementation ADBMylistExport
- (id)init
{
	if ([super init])
	{
		document = nil;
		mylist = [NSArray array];
		att = [[NSDictionary dictionaryWithObjects:ADBMylistExportKeyArray
												  forKeys:ADBMylistExportKeyArray] retain];
	}
	return self;
}

- (void)dealloc
{
	[document release];
	[mylist release];
	[att release];
	[super dealloc];
}

+ (ADBMylistExport*)mylistExportWithPath:(NSString*)absolutePath
{
	ADBMylistExport* temp = [[ADBMylistExport alloc] init];
	[temp readXMLFromPath:absolutePath];
	return temp;
}

- (BOOL)readXMLFromPath:(NSString*)absolutePath
{
	if (document == nil)
	{
		NSError* error = nil;
		document = [[[NSXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:absolutePath]
												options:0
												  error:&error] retain];
		if (error == nil)
		{
			[self setAtt:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[document rootElement] attributeForName:@"uid"] stringValue], [[[document rootElement] attributeForName:@"username"] stringValue], [[[document rootElement] attributeForName:@"date"] stringValue], [[[document rootElement] attributeForName:@"size"] stringValue], nil]
															forKeys:ADBMylistExportKeyArray]];
			return YES;
		}
	}
	return NO;
		
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
