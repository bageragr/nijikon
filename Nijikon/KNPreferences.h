//
//  KNPreferences.h
//  Nijikon
//
//  Created by Pipelynx on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNKeyArrays.h"


@interface KNPreferences : NSObject {
	NSString* path;
	NSXMLDocument* document;
	
	NSMutableDictionary* att;
}

+ (KNPreferences*)preferenceWithPath:(NSString*)absolutePath;

- (void)populateDocument;
- (void)readPreferences;
- (void)persistPreferences;

- (NSString*)path;
- (void)setPath:(NSString*)newPath;
- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

@end
