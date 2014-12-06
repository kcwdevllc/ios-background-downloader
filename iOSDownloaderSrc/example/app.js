// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

// ENTER URLS to download must be different urls
var URL1 = 'URL 1';
var URL2 = 'URL 2';
var URL3 = 'URL 3';
var URL4 = 'URL 4';


// open a single window
var window = Ti.UI.createWindow({
});
window.open();

// TODO: write your module tests here
var downloader = require('com.kcwdev.downloader');
Ti.API.info("module is => " + downloader);
downloader.permittedNetworkTypes = downloader.NETWORK_TYPE_ANY;
downloader.maximumSimultaneousDownloads = 4;

var scrollView = Ti.UI.createScrollView({
    top:0,
    bottom:0,
    left:0,
    right:0,
    scrollType: 'vertical',
    layout:'vertical',
    contentHeight:'auto'
});

var progressOptions = {
    top:10,
    left: 10,
    right:10,
    min:0,
    max:100,
    value:0,
    height:10,
};
var labelOptions = {
    top:0,
    left:10,
    right:10,
    height:20,
    text:'Waiting',
    color:'#fff'
};

var progress1 = Ti.UI.createProgressBar(progressOptions);
scrollView.add(progress1);
progress1.show();
var label1 = Ti.UI.createLabel(labelOptions);
scrollView.add(label1);

var progress2 = Ti.UI.createProgressBar(progressOptions);
scrollView.add(progress2);
progress2.show();
var label2 = Ti.UI.createLabel(labelOptions);
scrollView.add(label2);

var progress3 = Ti.UI.createProgressBar(progressOptions);
scrollView.add(progress3);
progress3.show();
var label3 = Ti.UI.createLabel(labelOptions);
scrollView.add(label3);

var progress4 = Ti.UI.createProgressBar(progressOptions);
scrollView.add(progress4);
progress4.show();
var label4 = Ti.UI.createLabel(labelOptions);
scrollView.add(label4);


var cancelButton = Ti.UI.createButton({
    top:10,
    left:10,
    right:10,
    height:40,
    title: 'Cancel All',
});
cancelButton.addEventListener('click', function() {
    downloader.cancelItem(URL1);
    downloader.cancelItem(URL2);
    downloader.cancelItem(URL3);
    downloader.cancelItem(URL4);    
});
scrollView.add(cancelButton);

var pauseButton = Ti.UI.createButton({
    title: 'Pause All',
    top:10,
    left:10,
    right:10,
    height:40,
});
pauseButton.addEventListener('click', function() {
    downloader.pauseAll();
});

scrollView.add(pauseButton);

var resumeButton = Ti.UI.createButton({
    top:10,
    left:10,
    right:10,
    height:40,
    title: 'Resume All',
});
resumeButton.addEventListener('click', function() {
    downloader.resumeAll();
});
scrollView.add(resumeButton);

var startButton = Ti.UI.createButton({
    top:10,
    left:10,
    right:10,
    height:40,
    title: 'Start Download',
});
startButton.addEventListener('click', function() {
    Ti.API.info('Deleting any existing files');
        
    downloader.cancelItem(URL1);
    downloader.cancelItem(URL2);
    downloader.deleteItem(URL3);
    downloader.deleteItem(URL4);    

    var file1 = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory,'File1.bin');
    if (file1.exists) {
        file1.deleteFile();
    }
    var file2 = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory,'File2.bin');
    if (file2.exists) {
        file2.deleteFile();
    }
    var file3 = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory,'File3.bin');
    if (file3.exists) {
        file3.deleteFile();
    }
    var file4 = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory,'File4.bin');
    if (file4.exists) {
        file4.deleteFile();
    }

    Ti.API.info('Adding items to the downloader.');
    downloader.addDownload({name: 'name 1', url:URL1, filePath:file1.nativePath});
    downloader.addDownload({name: 'name 2', url:URL2, filePath:file2.nativePath});
    downloader.addDownload({name: 'name 3', url:URL3, filePath:file3.nativePath});
    downloader.addDownload({name: 'name 4', url:URL4, filePath:file4.nativePath});
    
    var info = downloader.getDownloadInfo(URL1);
    Ti.API.info('URL1 download info: ' + JSON.stringify(info));
    
});
scrollView.add(startButton);

window.add(scrollView);

 downloader.addEventListener('progress', function(e) {
     var progress = e.downloadedBytes * 100.0 / e.totalBytes;
     var text = e.downloadedBytes + '/' + e.totalBytes + ' ' + Math.round(progress)+ '% ' +  e.bps + ' bps';
 
     if (e.url == URL1) {
         label1.text = text
         progress1.value = progress;
     } else if (e.url == URL2) {
         label2.text = text
         progress2.value = progress; 
     } else if (e.url == URL3) {
         label3.text = text
         progress3.value = progress; 
     } else if (e.url == URL4) {
         label4.text = text
         progress4.value = progress; 
     }
 
 });
 
 downloader.addEventListener('completed', function(e) {
     if (e.url == URL1) {
         label1.text = 'Download Complete';
         progress1.value = e.progress;
     } else if (e.url == URL2) {
         label2.text = 'Download Complete';
         progress2.value = e.progress; 
     } else if (e.url == URL3) {
         label3.text = 'Download Complete';
         progress3.value = e.progress; 
     } else if (e.url == URL4) {
         label4.text = 'Download Complete';
         progress4.value = e.progress; 
     }
 });