//
//  PLED2k.m
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "PLED2k.h"


@implementation PLED2k
+ (NSArray*)getED2kAndSize:(NSString*)path {
	NSData* file = [NSData dataWithContentsOfFile:path];
	unsigned char rDigest[16];
	unsigned char bDigest[16];
	const unsigned char* data = [file bytes];
	int len = [file length];
	
	if (len <= BLOCKSIZE) {
		MD4(data, len, bDigest);
		if (len == BLOCKSIZE) {
			MD4(rDigest, 0, rDigest);
			unsigned char hashlist[32];
			memcpy(hashlist, bDigest, 16);
			memcpy(hashlist + 16, rDigest, 16);
			MD4(hashlist, 32, rDigest);
		} else
			memcpy(rDigest, bDigest, 16);
	} else {
		int blocks = (len - (len % BLOCKSIZE)) / BLOCKSIZE;
		unsigned char* hashlist = malloc(((blocks + 1) * 16));
		memset(hashlist, 0x00, (blocks + 1) * 16);
		int i;
		for (i = 0; i < blocks; i++) {
			MD4(data, BLOCKSIZE, bDigest);
			memcpy(hashlist + (i * 16), bDigest, 16);
			data += BLOCKSIZE;
		}
		MD4(data, len % BLOCKSIZE, bDigest);
		memcpy(hashlist + (blocks * 16), bDigest, 16);
		MD4(hashlist, (blocks + 1) * 16, rDigest);
		if ((len % BLOCKSIZE) == 0)
			MD4(hashlist, blocks * 16, bDigest);
		else
			memcpy(bDigest, rDigest, 16);
		free(hashlist);
	}
	
	[file release];
	
	return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",len], [self getHex:rDigest], nil ];
}
+ (NSString*)getED2k:(NSString*)path {
	NSData* file = [NSData dataWithContentsOfFile:path];
	unsigned char rDigest[16];
	unsigned char bDigest[16];
	const unsigned char* data = [file bytes];
	int len = [file length];
	
	if (len <= BLOCKSIZE) {
		MD4(data, len, bDigest);
		if (len == BLOCKSIZE) {
			MD4(rDigest, 0, rDigest);
			unsigned char hashlist[32];
			memcpy(hashlist, bDigest, 16);
			memcpy(hashlist + 16, rDigest, 16);
			MD4(hashlist, 32, rDigest);
		} else
			memcpy(rDigest, bDigest, 16);
	} else {
		int blocks = (len - (len % BLOCKSIZE)) / BLOCKSIZE;
		unsigned char* hashlist = malloc(((blocks + 1) * 16));
		memset(hashlist, 0x00, (blocks + 1) * 16);
		int i;
		for (i = 0; i < blocks; i++) {
			MD4(data, BLOCKSIZE, bDigest);
			memcpy(hashlist + (i * 16), bDigest, 16);
			data += BLOCKSIZE;
		}
		MD4(data, len % BLOCKSIZE, bDigest);
		memcpy(hashlist + (blocks * 16), bDigest, 16);
		MD4(hashlist, (blocks + 1) * 16, rDigest);
		if ((len % BLOCKSIZE) == 0)
			MD4(hashlist, blocks * 16, bDigest);
		else
			memcpy(bDigest, rDigest, 16);
		free(hashlist);
	}
	
	[file release];
	
	return [self getHex:rDigest];
}

+ (NSString*)getHex:(unsigned char*)digest {
	char hexstr[32];
	const char hexdgts[16] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
	int i = 0;
	for (i = 0; i < 16; i++) {
		hexstr[(i * 2)] = hexdgts[(digest[i] & 0xf0) >> 4];
		hexstr[(i * 2) + 1] = hexdgts[(digest[i] & 0x0f)];
	}
	return [[NSString stringWithUTF8String:hexstr] lowercaseString];
}

+ (BOOL)isSupportedFileType:(NSString*)path {
	NSArray* fileTypes = SUPPORTED_FILE_TYPES;
	for (int i = 0; i < [fileTypes count]; i++) {
		if ([[path pathExtension] caseInsensitiveCompare:[fileTypes objectAtIndex:i]] == NSOrderedSame)
			return YES;
	}
	return NO;
}
@end
