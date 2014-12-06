//
//  SingleDownload.m
//  downloader
//
//  Created by Kevin Willford on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleDownload.h"

@interface SingleDownload()
{
    long bytesForBPS;
    int trackBpsIterationCount;
    int fireProgressEventCount;
    int TRACK_BPS_ON_ITERATION_NUMBER;
    int FIRE_PROGRESS_EVENT_ON_ITERATION_NUMBER;
    NSDate* bpsTrackingStart;
    DownloadInformation* downloadInformation;
    NSURLConnection* urlConnection;
    NSThread* downloadThread;
    //NSOutputStream* outputStream;
}


@end



@implementation SingleDownload

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        bytesForBPS = 0;
        trackBpsIterationCount = 0;
        fireProgressEventCount = 0;
        TRACK_BPS_ON_ITERATION_NUMBER = 30;
        FIRE_PROGRESS_EVENT_ON_ITERATION_NUMBER = 4;
    }
    
    return self;
}

-(void)dealloc
{
    [self.downloadRequest release];
    [self.permittedNetworks release];
    [self.delegate release];
    [bpsTrackingStart release];
    [urlConnection release];
    [downloadInformation release];
    [downloadThread release];
    
    [super dealloc];     
}

@synthesize delegate = _delegate;
@synthesize downloadRequest = _downloadRequest;
@synthesize permittedNetworks = _permittedNetworks;


-(void)start
{                    
    downloadThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadThread) object:nil];
    [downloadThread setThreadPriority:[self.downloadRequest priority]];
    NSString* threadName = @"DownloadThread: ";
    [downloadThread setName:[threadName stringByAppendingString:[self.downloadRequest name]]];
    
    [self.downloadRequest setStatus:DownloadStatusInProgress];
    [downloadThread start];
}



-(void)downloadThread
{           
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    downloadInformation = [[DownloadInformation alloc] init];
    [downloadInformation setUrl:[self.downloadRequest url]];
    [downloadInformation setName:[self.downloadRequest name]];
    [downloadInformation setLocale:[self.downloadRequest locale]];
    [downloadInformation setFilePath:[self.downloadRequest filePath]];
    [downloadInformation setLength:[self.downloadRequest length]];
    [downloadInformation setMediaBitsPerSecond:[self.downloadRequest mediaBitsPerSecond]];
    [downloadInformation setAvailableLength:[self.downloadRequest availableLength]];
    [downloadInformation setCreationUtc:[self.downloadRequest creationUtc]];
    [downloadInformation setLastWriteUtc:[self.downloadRequest lastWriteUtc]];
    [downloadInformation setLastDownloadBitsPerSecond:[self.downloadRequest lastDownloadBitsPerSecond]];
    [downloadInformation setDownloadPriority:[self.downloadRequest priority]];
    [downloadInformation setIsReadyForPlayback:[self.downloadRequest isReadyForPlayback]];
    [downloadInformation setPermittedNetworkTypes:[self.downloadRequest finalPermittedNetworkTypes]];
    [downloadInformation setStorageLocation:[self.downloadRequest finalStorageLocation]];
    
    
    downloadInformation.message = @"resume";
    NSFileManager* fileMan = [[[NSFileManager alloc] init] autorelease];    
    //NSLog(@"Checking if file exists. %@", [downloadRequest filePath]);            
    if ([fileMan fileExistsAtPath:[self.downloadRequest filePath]] == false)
    {
        downloadInformation.message = @"start";
        [fileMan createDirectoryAtPath:[[self.downloadRequest filePath] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];        
        // create new file                
        NSError* error;
        BOOL result = [fileMan createFileAtPath:[self.downloadRequest filePath] contents:nil attributes:nil];
        if (result == YES)
        {
            NSLog(@"File successfully created.");                        
        }
        else
        {
            NSLog(@"Failed to create file. %@", [error debugDescription]);                                    
        }
    }
    
    UInt32 size = [[fileMan attributesOfItemAtPath:[self.downloadRequest filePath] error:nil] fileSize];
    NSLog(@"File Size %lu of %d", size, [self.downloadRequest length]);            
    if (size != [self.downloadRequest availableLength])
    {
        [self.downloadRequest setAvailableLength:size];
    }
    
    [self startRequest];
    [self.delegate downloadStarted:downloadInformation];
    
    CFRunLoopRun();
    [urlConnection release];
    urlConnection = nil;
    [downloadInformation release];
    downloadInformation = nil;
    [pool drain];
    
}

-(void)startRequest
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.downloadRequest url]]];
    [request setHTTPMethod:@"GET"];
    
    if ([self.downloadRequest availableLength] > 0)
    {
        NSString* range = @"bytes=";
        range = [range stringByAppendingString:[[NSNumber numberWithInt:[self.downloadRequest availableLength]] stringValue]];
        range = [range stringByAppendingString:@"-"];
        //NSString* range = [NSString stringWithFormat:@"bytes=%i-", [downloadRequest availableLength]];
        
        NSLog(@"Setting Range Request %@", range);            
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    NSLog(@"Download Thread sending request.");            
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];    
}

#pragma mark NSURLConnection delegate methods
- (NSURLRequest *)connection:(NSURLConnection *)connection
 			 willSendRequest:(NSURLRequest *)request
 			redirectResponse:(NSURLResponse *)redirectResponse {
 	NSLog(@"Connection received data");
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.downloadRequest.status == DownloadStatusNone)
    {
        [self.downloadRequest setStatus:DownloadStatusInProgress];
    }
    
    //NSLog(@"Receive Data: %d", [data length]);
    NSUInteger byteCount = [data length];
    bytesForBPS += byteCount;
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self.downloadRequest filePath]];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle closeFile];
    
    [self.downloadRequest setAvailableLength:[self.downloadRequest availableLength] + byteCount];
    [self.downloadRequest setLastWriteUtc:[NSDate new]];
    [downloadInformation setLastWriteUtc:[self.downloadRequest lastWriteUtc]];
    [downloadInformation setAvailableLength:[self.downloadRequest availableLength]];
    
    // Track bits/second (every n iterations through loop)
    trackBpsIterationCount++;
    if (trackBpsIterationCount == TRACK_BPS_ON_ITERATION_NUMBER)
    {    
        double bpsTrackingSpan = [bpsTrackingStart timeIntervalSinceNow] * -1;
        if (bpsTrackingSpan > 0.0f)
        {
            double bps = (8.0f * bytesForBPS) / bpsTrackingSpan;                
            [self.downloadRequest setLastDownloadBitsPerSecond:bps];
            [downloadInformation setLastDownloadBitsPerSecond:[self.downloadRequest lastDownloadBitsPerSecond]];
        }
    }        
    
    
    // Fire progress event (every n iterations through loop)
    fireProgressEventCount++;
    if (fireProgressEventCount == FIRE_PROGRESS_EVENT_ON_ITERATION_NUMBER)
    {
        fireProgressEventCount = 0;
        [self.delegate downloadProgress:downloadInformation];
    }
    
    
    // Reset tracking of bits/second (every n iterations through loop)
    if (trackBpsIterationCount == TRACK_BPS_ON_ITERATION_NUMBER)
    {            
        trackBpsIterationCount = 0;
        bytesForBPS = 0;
        bpsTrackingStart = [NSDate new];
    }        
    
    
    if ([self.delegate canContinue:downloadInformation] == false)
    {
        NSLog(@"Download cancelled %@ - %d", [self.downloadRequest url], self.downloadRequest.status);
        if (self.downloadRequest.status == DownloadStatusInProgress)
        {
            [self.downloadRequest setStatus:DownloadStatusNone];
        }
        [urlConnection cancel];
        CFRunLoopStop(CFRunLoopGetCurrent());
    }   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([self.downloadRequest availableLength] == [self.downloadRequest length]) {        
        [self.downloadRequest setStatus:DownloadStatusComplete];
        [self.delegate downloadCompleted:downloadInformation];
        NSLog(@"Download finished loading %i / %i", [self.downloadRequest availableLength], [self.downloadRequest length]);
        CFRunLoopStop(CFRunLoopGetCurrent());
    } 
    else 
    {
        [urlConnection cancel];
        NSLog(@"Download invalid %i / %i", [self.downloadRequest availableLength], [self.downloadRequest length]);
        NSLog(@"Download invalid %@", [self.downloadRequest filePath]);
        NSLog(@"Download invalid %@", [self.downloadRequest url]);
        [[NSFileManager defaultManager] removeItemAtPath:[self.downloadRequest filePath] error:nil];
        [self.downloadRequest setAvailableLength:0];
        [self startRequest];
//        [delegate downloadProgress:downloadInformation];
//        [delegate downloadRestart:downloadInformation];
//        NSLog(@"Download finished loading not complete %i / %i", [downloadRequest availableLength], [downloadRequest length]);
//        CFRunLoopStop(CFRunLoopGetCurrent());        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    bpsTrackingStart = [NSDate new];
    NSLog(@"Download received response. Writing to %@", [self.downloadRequest filePath]);            
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([httpResponse respondsToSelector:@selector(allHeaderFields)])
    {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSString *acceptRanges = [dictionary valueForKey:@"Accept-Ranges"];
        if (acceptRanges == nil || acceptRanges == @"none")
        {
            NSLog(@"Server doesn't allow accept ranges so download the whole file. %@", [self.downloadRequest filePath]);
            [self.downloadRequest setAvailableLength:0];
            [downloadInformation setAvailableLength:0];
            
            NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self.downloadRequest filePath]];
            [fileHandle truncateFileAtOffset:0];
            [fileHandle closeFile];
        }
        else
        {
            NSLog(@"Server allows accept ranges so append to the file.");            
        }
        
        NSString *contentLength = [dictionary valueForKey:@"content-length"];        
        NSLog(@"Content length %@", contentLength);            
        
        if ([self.downloadRequest length] == 0)
        {
            [self.downloadRequest setLength:contentLength.integerValue];
            [downloadInformation setLength:contentLength.integerValue];
            [self.delegate downloadProgress:downloadInformation];
        }
    }
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    NSLog(@"Fetch failed: %@", [error localizedDescription]);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
