//
//  Downloader.h
//  downloader
//
//  Created by Kevin Willford on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DownloadQueue.h"
#import "DownloadRequest.h"
#import "CompletedDownloadCatalog.h"
#import "SingleDownload.h"

enum
{
    DownloaderStatusNone,
    DownloaderStatusStarted,
    DownloaderStatusPaused
};
typedef NSInteger DownloaderStatus;


@protocol DownloaderDelegate <NSObject>
-(void)itemPaused:(DownloadInformation*)downloadInformation;
-(void)failed:(DownloadInformation*)downloadInformation;
-(void)progress:(DownloadInformation*)downloadInformation;
-(void)completed:(DownloadInformation*)downloadInformation;
-(void)cancelled:(DownloadInformation*)downloadInformation;
-(void)started:(DownloadInformation*)downloadInformation;
@end


@interface Downloader : NSObject <SingleDownloadDelegate>
{
}

@property (retain, nonatomic) id <DownloaderDelegate> delegate;
@property (readonly) NSInteger identifier;
@property (readonly) DownloaderStatus status;
@property (retain) NSString* defaultStorageLocation;
@property NSUInteger maximumSimultaneousDownloads;
@property NetworkTypes permittedNetworkTypes;
@property NSUInteger storageBytesQuota;
@property (readonly) NSUInteger storageBytesUsed;
@property (readonly) DownloadQueue* downloadQueue;


-(NSUInteger)storageBytesAvailable;

-(void)cancelItems:(NSArray*)urls;
-(void)cancelItem:(NSString*)url;

-(void)deleteItems:(NSArray*)urls;
-(void)deleteItem:(NSString*)url;

-(void)downloadItems:(NSArray*)items;
-(void)downloadItem:(DownloadRequest*)downloadRequest;

-(NSArray*)downloadInformationAll;
-(NSArray*)downloadInformationFromList:(NSArray*)urls;
-(DownloadInformation*)downloadInformationSingle:(NSString*)url;

-(void)stop;
-(void)start;

-(void)pauseAll;
-(void)pauseItems:(NSArray*)urls;
-(void)pauseItem:(NSString*)url;


-(void)restart:(NSString*)url;
-(void)restart:(NSString *)url
      atOffset:(NSUInteger)byteOffset;

-(void)resumeAll;
-(void)resumeItems:(NSArray*)urls;
-(void)resumeItem:(NSString*)url;

-(void)stopControllerThread;
-(void)startControllerThread:(double)waitSeconds;
-(void)stopAllDownloading;
-(NetworkTypes)networkTypes;



@end
