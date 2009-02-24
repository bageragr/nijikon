//
//  ADBObject.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBObject.h"


@implementation ADBObject
- (id)init {
	if ([super init]) {
		att = nil;
	}
	return self;
}

- (void)dealloc {
	[att release];
	[super dealloc];
}

- (NSMutableDictionary*)att {
	return att;
}

- (void)setAtt:(NSDictionary*)newAtt {
	if (att != newAtt)
	{
		[att release];
		att = [[NSMutableDictionary dictionaryWithDictionary:newAtt] retain];
		if ([att valueForKeyPath:@"pic"] != nil)
			[att setValue:[NSString stringWithFormat:@"http://img5.anidb.net/pics/anime/%@", [att valueForKeyPath:@"pic"]] forKey:@"pic"];
	}
}
@end
