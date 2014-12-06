/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComKcwdevDownloaderModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@interface ComKcwdevDownloaderModule()
{
    Downloader* downloader;
}

-(NSMutableDictionary*)createDict:(DownloadInformation*)di;

@end

@implementation ComKcwdevDownloaderModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b668bccf-f525-4263-99cf-ae0ae7d14248";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.kcwdev.downloader";
}

#pragma mark Lifecycle

-(void)startup
{
    downloader = [[Downloader alloc] init];
    [downloader setDelegate:self];
    [downloader setMaximumSimultaneousDownloads:2];

	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
    
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
    [downloader stop];
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
    RELEASE_TO_NIL(downloader);
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"progress"])
	{
        //[self fireEvent:@"progress" withObject:[self createDict:di]];
	}
    else if (count == 1 && [type isEqualToString:@"paused"])
    {
    }
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"progress"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
        //[self fireEvent:@"progress" withObject:[self createDict:di]];
	}
    else if (count == 0 && [type isEqualToString:@"paused"])
    {
        //[self fireEvent:@"progress" withObject:[self createDict:di]];
    }
}

#pragma Public APIs

MAKE_SYSTEM_PROP(NETWORK_TYPE_WIFI, 0)
MAKE_SYSTEM_PROP(NETWORK_TYPE_MOBILE, 1)
MAKE_SYSTEM_PROP(NETWORK_TYPE_ANY, 2)

MAKE_SYSTEM_PROP_DBL(DOWNLOAD_PRIORITY_LOW, 0.1)
MAKE_SYSTEM_PROP_DBL(DOWNLOAD_PRIORITY_NORMAL, 0.2)
MAKE_SYSTEM_PROP_DBL(DOWNLOAD_PRIORITY_HIGH, 0.3)

-(void)setMaximumSimultaneousDownloads:(id)value
{
    NSLog(@"Set Maximum Simultaneous Downloads to %@", value);
    [self replaceValue:value forKey:@"maximumSimulataneousDownloads" notification:NO];
    [downloader setMaximumSimultaneousDownloads:[TiUtils intValue:value]];
}

-(id)maximumSimultaneousDownloads
{
    return [self valueForUndefinedKey:@"maximumSimulataneousDownloads"];;
}

-(void)setPermittedNetworkTypes:(id)value
{
    NSLog(@"Set Permitted Network Types to %@", value);
    // NSInteger* number = NUMINT(value);
    
    [self replaceValue:value forKey:@"permittedNetworkTypes" notification:NO];
    if ([TiUtils intValue:value] == 0)
    {
        [downloader setPermittedNetworkTypes:NetworkTypeWireless80211];
    }
    else if ([TiUtils intValue:value] == 1)
    {
        [downloader setPermittedNetworkTypes:NetworkTypeMobile];
    }
    else if ([TiUtils intValue:value] == 2)
    {
        [downloader setPermittedNetworkTypes:NetworkTypeNetworkTypeAny];
    }
}

-(id)permittedNetworkTypes
{
    return [self valueForUndefinedKey:@"permittedNetworkTypes"];;
}

-(void)addDownload:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    DownloadRequest* request = [[DownloadRequest alloc] init];
    [request setUrl:[args objectForKey:@"url"]];
    [request setName:[args objectForKey:@"name"]];
    [request setLocale:@"eng"];
    
    // NSURL* fileurl = [NSURL fileURLWithPath:[args objectForKey:@"filePath"]];
    // [[fileurl filePathURL]
    
    NSURL* fileurl = [TiUtils toURL:[args objectForKey:@"filePath"] proxy:nil];
    
//    NSURL* fileurl = [NSURL fileURLWithPath:[args objectForKey:@"filePath"]];
//    NSURL* tempurl = [TiUtils toURL:[fileurl absoluteString] proxy:self];
//    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
    [request setFilePath:[fileurl path]];
    
    [downloader downloadItem:request];
}

-(void)stopDownloader:(id)args
{
    [downloader stop];
}

-(void)restartDownloader:(id)args
{
    [downloader start];
}

-(void)pauseAll:(id)args
{
    [downloader pauseAll];
}
-(void)pauseItem:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
    [downloader pauseItem:args];
}
-(void)resumeAll:(id)args
{
    [downloader resumeAll];
}
-(void)resumeItem:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
    [downloader resumeItem:args];
}
-(void)cancelItem:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
    [downloader cancelItem:args];
}
-(void)deleteItem:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
   [downloader deleteItem:args];
}
-(id)getDownloadInfo:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
    
    DownloadInformation* di = [downloader downloadInformationSingle:args];
    if (di == nil)
    {
        return nil;
    }
    
    return [self createDict:di];
}

-(id)getAllDownloadInfo:(id)args
{
    NSMutableArray* returnInfo = [[[NSMutableArray alloc]init]autorelease];
    NSArray* info = [downloader downloadInformationAll];
    for (DownloadInformation* di in info)
    {
        [returnInfo addObject: [self createDict:di]];
    }
        
    return returnInfo;
}

-(void)itemPaused:(DownloadInformation*)downloadInformation
{
    if ([self _hasListeners:@"paused"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        [self fireEvent:@"paused" withObject:[self createDict:downloadInformation]];
        [downloadInformation release];
    }
}


-(void)failed:(DownloadInformation*)downloadInformation
{
    if ([self _hasListeners:@"failed"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        [self fireEvent:@"failed" withObject:[self createDict:downloadInformation]];    
        [downloadInformation release];
    }
}
-(void)progress:(DownloadInformation*)downloadInformation
{
    if ([self _hasListeners:@"progress"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        [self fireEvent:@"progress" withObject:[self createDict:downloadInformation]];    
        [downloadInformation release];
    }
}
-(void)completed:(DownloadInformation*)downloadInformation
{
    if ([self _hasListeners:@"completed"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        [self fireEvent:@"completed" withObject:[self createDict:downloadInformation]];
        [downloadInformation release];
    }
}
-(void)cancelled:(DownloadInformation*)downloadInformation
{
    if ([self _hasListeners:@"cancelled"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        [self fireEvent:@"cancelled" withObject:[self createDict:downloadInformation]];
        [downloadInformation release];
    }
}
-(void)started:(DownloadInformation *)downloadInformation
{
    if ([self _hasListeners:@"started"])
    {
        [downloadInformation retain];
        ENSURE_UI_THREAD_1_ARG(downloadInformation);
        NSMutableDictionary* dict = [self createDict:downloadInformation];
        [dict setValue:downloadInformation.message forKey:@"reason"];
        [self fireEvent:@"started" withObject:dict];
        [downloadInformation release];
    }    
}



-(NSMutableDictionary*)createDict:(DownloadInformation*)di
{
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:[di name]  forKey:@"name"];
    [dict setValue:[di url]  forKey:@"url"];
    [dict setValue:NUMINT([di availableLength])  forKey:@"downloadedBytes"];
    [dict setValue:NUMINT([di length])  forKey:@"totalBytes"];
    [dict setValue:NUMINT([di lastDownloadBitsPerSecond])  forKey:@"bps"];
    [dict setValue:[di filePath]  forKey:@"filePath"];
    [dict setValue:[di creationUtc] forKey:@"createdDate"];
    [dict setValue:NUMDOUBLE([di downloadPriority]) forKey:@"priority"];
    
    return dict;    
}


@end
