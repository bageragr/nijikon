//
//  NSXMLNode+Extensions.h
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSXMLNode(KNExtensions)

- (NSXMLNode *)childForName:(NSString *)name;
- (NSArray *)childrenAsStrings;

@end
