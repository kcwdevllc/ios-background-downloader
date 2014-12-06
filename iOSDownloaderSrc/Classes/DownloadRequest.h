//
//  DownloadRequest.h
//  downloader
//
//  Created by Kevin Willford on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "BaseDownloadRequest.h"

@interface DownloadRequest : BaseDownloadRequest <NSCoding>
{
}

@property (retain) NSString* filePath;
@property (retain) NSString* url;
@property (retain) NSString* fileName;
@property NSInteger mediaBitsPerSecond;

@property (retain) NSDate* lastWriteUtc;
@property NSInteger lastDownloadBitsPerSecond;
@property BOOL isReadyForPlayback;

-(NSDictionary*)convertToDict;
-(void)initWithDict:(NSDictionary*)data;


@end
