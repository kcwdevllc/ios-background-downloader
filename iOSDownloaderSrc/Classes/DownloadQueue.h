//
//  DownloadQueue.h
//  downloader
//
//  Created by Kevin Willford on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkTypes.h"
#import "DownloadRequest.h"


@interface DownloadQueue : NSObject
{
}

@property (retain, readonly) NSMutableArray* downloadRequests;

-(NSUInteger)getDownloadRequestCount;
-(DownloadRequest*)remove:(NSString*)url;
-(void)add:(DownloadRequest*)downloadRequest
defaultStorageLocation:(NSString*)storageLocation
defaultPermittedNetworks:(NetworkTypes)permittedNetworks;

-(DownloadRequest*)getDownloadRequest:(NSString*)url;
-(void)setRequest:(NSString*)url
         toStatus:(DownloadStatus)status;
-(NSArray*)getQueuedDownloadRequestUrls;
-(DownloadRequest*)getNextDownloadCandidate:(NetworkTypes)network;
-(NSArray*)permittedNetworkTypesChanged:(NetworkTypes)permitted;

-(void)persistToStorage;
-(void)loadFromStorage;

@end
