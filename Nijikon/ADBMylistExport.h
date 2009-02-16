//
//  ADBMylistExport.h
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBKeyArrays.h"


@interface ADBMylistExport : NSObject {
	NSXMLDocument* document;
	NSArray* mylist;
	NSMutableDictionary* properties;
}

+ (ADBMylistExport*)mylistExportWithPath:(NSString*)path;

- (BOOL)readXMLFromPath:(NSString*)absolutePath;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSDictionary*)newProperties;

@end
