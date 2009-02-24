//
//  ADBMylistExport.h
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBKeyArrays.h"
#import "NSXMLNode+Extensions.h"


@interface ADBMylistExport : NSObject {
	NSXMLDocument* document;
	NSArray* mylist;
	NSMutableDictionary* att;
}

+ (ADBMylistExport*)mylistExportWithPath:(NSString*)path;

- (BOOL)readXMLFromPath:(NSString*)absolutePath;

- (NSArray*)mylistIDs;

- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

@end
