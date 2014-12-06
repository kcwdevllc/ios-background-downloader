//
//  CompletedDownloadCatalog.h
//  downloader
//
//  Created by Kevin Willford on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadInformation.h"

@interface CompletedDownloadCatalog : NSObject
{
}

-(void)deleteCompletedDownload:(NSString*)url;
-(void)addCompletedDownload:(DownloadInformation*)downloadInformation;
-(DownloadInformation*)getDownloadInformation:(NSString*)url;
-(void)persistToStorage;
-(void)loadFromStorage;
-(NSString*)MD5:(NSString*)value;

@end
