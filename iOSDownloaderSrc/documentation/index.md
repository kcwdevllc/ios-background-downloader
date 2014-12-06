# downloader Module

## Description

This is a downloader that allows you to add urls and download the files in the background

## Accessing the downloader Module

To access this module from JavaScript, you would do the following:

	var downloader = require("com.kcwdev.downloader");

The downloader variable is a reference to the Module object.	

## Reference

### Downloader Network Types Constants

	downloader.NETWORK_TYPE_WIFI
	downloader.NETWORK_TYPE_MOBILE
	downloader.NETWORK_TYPE_ANY

### Downloader Priority Constants

	downloader.DOWNLOAD_PRIORITY_LOW
	downloader.DOWNLOAD_PRIORITY_NORMAL
	downloader.DOWNLOAD_PRIORITY_HIGH

### Downloader events

	downloader.addEventListener('progress', handleEvent);
	downloader.addEventListener('paused', handleEvent);
	downloader.addEventListener('failed', handleEvent);
	downloader.addEventListener('completed', handleEvent);
	downloader.addEventListener('cancelled', handleEvent);
	downloader.addEventListener('started', handleEvent);

	handleEvent for started will have a reason property with either 'start' or 'resume'

All events send an object of the download information.  Example of event handler
	
	function handleEvent(e) {
		e.name;
		e.url;
		e.downloadedBytes;
		e.totalBytes;
		e.filePath;
		e.createdDate;
		e.priority;
	}

### ___PROJECTNAMEASIDENTIFIER__.maximumSimultaneousDownloads

	downlooader.maximumSimultaneousDownloads = 4;
	var maxDownloads = downlooader.getMaximumSimultaneousDownloads();
	downlooader.setMaximumSimultaneousDownloads(4);
	
### ___PROJECTNAMEASIDENTIFIER__.permittedNetworkTypes

	downlooader.permittedNetworkTypes = downloader.NETWORK_TYPE_ANY;
	var maxDownloads = downlooader.getPermittedNetworkTypes();
	downlooader.setPermittedNetworkTypes(downloader.NETWORK_TYPE_WIFI);

### ___PROJECTNAMEASIDENTIFIER__.addDownload

	downloader.addDownload({
		name:'Some name',
		url:'http://host/file',
		filePath: 'native file path',
		priority:downloader.DOWNLOAD_PRIORITY_NORMAL
	});
### ___PROJECTNAMEASIDENTIFIER__.stopDownloader

	downloader. stopDownloader();

### ___PROJECTNAMEASIDENTIFIER__.restartDownloader

	downloader. restartDownloader();

### ___PROJECTNAMEASIDENTIFIER__.pauseAll

	downloader.pauseAll();

### ___PROJECTNAMEASIDENTIFIER__.pauseItem

	downloader.pauseItem('http://host/file');

### ___PROJECTNAMEASIDENTIFIER__.resumeAll

	downloader.resumeAll();

### ___PROJECTNAMEASIDENTIFIER__.resumeItem

	downloader.resumeItem('http://host/file');

### ___PROJECTNAMEASIDENTIFIER__.cancelItem

	downloader.cancelItem('http://host/file');

### ___PROJECTNAMEASIDENTIFIER__.deleteItem

	downloader.deleteItem('http://host/file');

### ___PROJECTNAMEASIDENTIFIER__.getDownloadInfo

	downloader.getDownloadInfo('http://host/file');

### ___PROJECTNAMEASIDENTIFIER__.getAllDownloadInfo

	downloader.getAllDownloadInfo();

## Usage

	var downloader = require('com.kcwdev.downloader');
	downloader.permittedNetworkTypes = downloader.NETWORK_TYPE_ANY;
	downloader.maximumSimultaneousDownloads = 4;
	downloader.addEventListener('progress', function(e) {
	    var progress = e.downloadedBytes * 100.0 / e.totalBytes;
	    var text = e.downloadedBytes + '/' + e.totalBytes + ' ' + Math.round(progress)+ '% ' +  e.bps + ' bps';	
	});

	downloader.addDownload({name: 'name 1', url:URL1, filePath:file1.nativePath, priority: downloader.DOWNLOAD_PRIORITY_NORMAL});
    downloader.addDownload({name: 'name 2', url:URL2, filePath:file2.nativePath, priority: downloader.DOWNLOAD_PRIORITY_LOW});
    downloader.addDownload({name: 'name 3', url:URL3, filePath:file3.nativePath, priority: downloader.DOWNLOAD_PRIORITY_HIGH});
    downloader.addDownload({name: 'name 4', url:URL4, filePath:file4.nativePath, priority: downloader.DOWNLOAD_PRIORITY_LOW});


## Author

Kevin Willford

## License

TODO: Enter your license/legal information here.
