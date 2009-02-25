//
//  KNPreferences.h
//  Nijikon
//
//  Created by Pipelynx on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNKeyArrays.h"


@interface PLPreferences : NSObject {
	NSString* path;
	NSXMLDocument* document;
	
	NSMutableDictionary* att;
}

+ (PLPreferences*)preferenceWithPath:(NSString*)absolutePath;

- (void)populateDocument;
- (void)readPreferences;
- (void)persistPreferences;

- (NSString*)path;
- (void)setPath:(NSString*)newPath;
- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

@end
