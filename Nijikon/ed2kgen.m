#define SERVER @"api.anidb.net"
#define REMOTE_PORT 9000
#define LOCAL_PORT 12345

#import <Foundation/Foundation.h>
#import "PLED2k.h"
#import "ADBFacade.h"
#import "ADBFile.h"

int main (int argc, const char * argv[]) {
	if (argc < 3) {
		printf("usage:\ned2kgen anidbuser anidbpwd File1|Directory1 ...\n");
		return 1;
	}
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	ADBFacade* facade = [ADBFacade facadeWithHost:[NSHost hostWithName:SERVER] remotePort:REMOTE_PORT andLocalPort:LOCAL_PORT];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	BOOL isDir, isSubdir;
	int param, paramCount;
	NSString* user;
	NSString* password;
    NSString* path;
	NSString* subpath;
	ADBFile* file;
	NSArray* hashResult;
	NSMutableString* hashes;
	NSArray* contents;
	
	param = 0;
	paramCount = argc - 3;
	
	user = [NSString stringWithUTF8String:argv[1]];
	password = [NSString stringWithUTF8String:argv[2]];
	
	[facade login:user withPassword:password];
	
	//iterating through parameters
	while (param < paramCount) {
		//assign parameter to variable
		path = [NSString stringWithUTF8String:argv[param + 3]];
		//check if file exists and assign directory flag
		if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
			//in case the file is a directory
			if (isDir) {
				contents = [fm directoryContentsAtPath:path];
				hashes = [NSMutableString string];
				for (int i = 0; i < [contents count]; i++) {
					subpath = [path stringByAppendingPathComponent:[contents objectAtIndex:i]];
					if ([fm fileExistsAtPath:subpath isDirectory:&isSubdir])
						if (!isSubdir && [PLED2k isSupportedFileType:subpath]) {
							printf("Hashing \"%s\"...", [[contents objectAtIndex:i] UTF8String]);
							hashResult = [PLED2k getED2kAndSize:subpath];
							file = [facade findFileBySize:[hashResult objectAtIndex:0] andED2k:[hashResult objectAtIndex:1]];
							file = [facade findFileByID:@"443032"];
							if (file != nil)
								[hashes appendFormat:@"ed2k://|file|%@|%@|%@|\n", [file valueForKeyPath:@"anidbAtt.filename"], [hashResult objectAtIndex:0], [hashResult objectAtIndex:1]];
							printf("[done]\n");
					}
				}
				if ([hashes length] > 0)
					[fm createFileAtPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_hashes.txt", [path lastPathComponent]]]
								contents:[hashes dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
			}
			//in case it is a single file
			else {
				printf("Hashing \"%s\"...", [[path stringByStandardizingPath] UTF8String]);
				hashes = [NSMutableString stringWithString:[PLED2k getED2k:path]];
				printf("[done]\n");
				if ([hashes length] > 0)
					[fm createFileAtPath:[[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[[[[path lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_hash"] stringByAppendingPathExtension:@"txt"]] 
								contents:[hashes dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
			}
		}
		else //in case file is not found
			printf("404 Not found: \"%s\"\n", [path UTF8String]);
		param++;
		NSLog(@"param++;");
	}
	
	[facade logout];
    
    [pool drain];
    return 0;
}

