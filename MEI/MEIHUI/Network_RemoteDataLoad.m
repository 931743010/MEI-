//
//  Network_RemoteDataLoad.m
//  NETWORK
//
//  Created by Yosemite on 2/4/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "Network_RemoteDataLoad.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define ITEMINFOSIZE 74/*size int = 4, size long = 8, size iteminfo = 56*/
#define INTEGERSIZE 8
#else
#define ITEMINFOSIZE 38/*size int = 4, size long = 4, size iteminfo = 28*/
#define INTEGERSIZE 4
#endif

#define MAXDOWNLOAD 16384

@interface Network_RemoteDataLoad ()
{
    NSString *_l1CacheDir;
    NSString *_l2CacheDir;
    NSString *_destDir;
}
@end

typedef struct iteminfo {
    NSInteger index;
    NSUInteger connection;
    NSUInteger urlstrhash;
    NSString *urlstr;
    NSString *l1cache;
    NSString *l2cache;
    NSFileHandle *filehandle;///
    NSDate *datemodified;///
    void (^didFinishLoad)(NSData *data);
    char cancelable;
    char canceled;
} iteminfo_t;
NSDateFormatter *__httpDateFormater = nil;
NSFileManager *__fm = nil;
dispatch_queue_t __mainqueue;
dispatch_queue_t __networkconcurrentqueue = nil;
dispatch_semaphore_t __networkqueuesemaphore = nil;
iteminfo_t __items[MAXDOWNLOAD];//不使用__items[0]，从index=1开始！
pthread_t __networkbackgroundthread;//...
pthread_mutex_t __mutex_status = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t __mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t __cond = PTHREAD_COND_INITIALIZER;

@implementation Network_RemoteDataLoad

- (id)init
{
    self = [super init];
    if (self) {
        __fm = [NSFileManager defaultManager];
        _l1CacheDir = [[NSTemporaryDirectory() stringByAppendingString:@"/Temp1764"] retain];
        _l2CacheDir = [[NSTemporaryDirectory() stringByAppendingString:@"/Cache1764"] retain];
        _destDir = [[NSHomeDirectory() stringByAppendingString:@"/Documents/Download"] retain];
        if (![__fm fileExistsAtPath:_l1CacheDir])
        {
            [__fm createDirectoryAtPath:_l1CacheDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (![__fm fileExistsAtPath:_l2CacheDir])
        {
            [__fm createDirectoryAtPath:_l2CacheDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (![__fm fileExistsAtPath:_destDir])
        {
            [__fm createDirectoryAtPath:_destDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (__httpDateFormater == nil)
        {
            __httpDateFormater = [NSDateFormatter new];
            [__httpDateFormater setTimeZone:[NSTimeZone defaultTimeZone]];
            [__httpDateFormater setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
        }
        if (!__mainqueue)
        {
            __mainqueue = dispatch_get_main_queue();
        }
        if (__networkconcurrentqueue == nil)
        {
            __networkconcurrentqueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, DISPATCH_QUEUE_PRIORITY_DEFAULT);//dispatch_queue_create("networkconcurrentqueue", DISPATCH_QUEUE_CONCURRENT);
        }
        if (__networkqueuesemaphore == nil)
        {
            __networkqueuesemaphore = dispatch_semaphore_create(1);
        }
    }
    return self;
}

- (void)dealloc
{
    [_l1CacheDir release];
    [_l2CacheDir release];
    [_destDir release];
    [super dealloc];
}

//- (void)doesNotRecognizeSelector:(SEL)aSelector
//{
//    [super doesNotRecognizeSelector:aSelector];
//}

- (void)loadDataFromURLWithString:(NSString *)URLString didFinishLoad:(void (^)(NSData *data))didFinishLoad
{
    dispatch_async(__networkconcurrentqueue, ^{
        dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
        NSUInteger newHash = [URLString hash];
        NSInteger count = __items[0].index;
        for (NSInteger i = 1; i < MAXDOWNLOAD; i++)
        {
            if (count == 0)
                break;
            if (__items[i].index != 0)
            {
                count--;
                if (__items[i].urlstrhash == newHash)
                {
                    dispatch_semaphore_signal(__networkqueuesemaphore);
                    return;
                }
            }
        }
        NSString *l1Cache = [self l1cacheFilePathOfURLWithHash:newHash];
        if ([__fm fileExistsAtPath:l1Cache])
        {
            dispatch_semaphore_signal(__networkqueuesemaphore);
            NSData *data = [NSData dataWithContentsOfFile:l1Cache];
            if (data)
            {
                dispatch_async(__mainqueue, ^{
                    didFinishLoad(data);
                });
            }
            return;
        }
        for (NSInteger i = 1; i < MAXDOWNLOAD; i++)
        {
            if (__items[i].index == 0) {
                __items[i].index = i;
                __items[i].urlstrhash = newHash;
                __items[i].urlstr = [URLString retain];
                __items[i].l1cache = [l1Cache retain];
                __items[i].l2cache = [[self l2cacheFilePathOfURLWithHash:newHash] retain];
                __items[i].didFinishLoad = [didFinishLoad retain];
                __items[i].cancelable = 1;
                [self connectToDownloadItemAtIndex:i];
                __items[0].index += 1;
                break;
            }
        }
        dispatch_semaphore_signal(__networkqueuesemaphore);
        return;
    });
}

- (void)loadDataIgnoringL1CacheFromURLWithString:(NSString *)URLString didFinishLoad:(void (^)(NSData *data))didFinishLoad
{
    dispatch_async(__networkconcurrentqueue, ^{
        dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
        NSUInteger newHash = [URLString hash];
        NSInteger count = __items[0].index;
        for (NSInteger i = 1; i < MAXDOWNLOAD; i++)
        {
            if (count == 0)
                break;
            if (__items[i].index != 0)
            {
                count--;
                if (__items[i].urlstrhash == newHash)
                {
                    dispatch_semaphore_signal(__networkqueuesemaphore);
                    return;
                }
            }
        }
        NSString *l1Cache = [self l1cacheFilePathOfURLWithHash:newHash];
        for (NSInteger i = 1; i < MAXDOWNLOAD; i++)
        {
            if (__items[i].index == 0) {
                __items[i].index = i;
                __items[i].urlstrhash = newHash;
                __items[i].urlstr = [URLString retain];
                __items[i].l1cache = [l1Cache retain];
                __items[i].l2cache = [[self l2cacheFilePathOfURLWithHash:newHash] retain];
                __items[i].didFinishLoad = [didFinishLoad retain];
                __items[i].cancelable = 1;
                [self connectToDownloadItemAtIndex:i];
                __items[0].index += 1;
                break;
            }
        }
        dispatch_semaphore_signal(__networkqueuesemaphore);
        return;
    });
}

- (void)emptyItemAtIndex:(NSInteger)index
{
    dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
    __items[index].urlstrhash = 0;
    __items[index].connection = 0;
    if (__items[index].urlstr) {
        [__items[index].urlstr release];
        __items[index].urlstr = nil;
    }
    if (__items[index].l1cache) {
        [__items[index].l1cache release];
        __items[index].l1cache = nil;
    }
    if (__items[index].l2cache) {
        [__items[index].l2cache release];
        __items[index].l2cache = nil;
    }
    if (__items[index].filehandle) {
        [__items[index].filehandle closeFile];
        [__items[index].filehandle release];
        __items[index].filehandle = nil;
    }
    if (__items[index].datemodified) {
        [__items[index].datemodified release];
        __items[index].datemodified = nil;
    }
    if (__items[index].didFinishLoad) {
        [__items[index].didFinishLoad release];
        __items[index].didFinishLoad = nil;
    }
    __items[index].index = 0;
    __items[index].cancelable = 0;
    __items[index].canceled = 0;
    __items[0].index -= 1;
    dispatch_semaphore_signal(__networkqueuesemaphore);
}

- (void)emptyCanceledItemAtIndex:(NSInteger)index
{
    __items[index].urlstrhash = 0;
    __items[index].connection = 0;
    if (__items[index].urlstr) {
        [__items[index].urlstr release];
        __items[index].urlstr = nil;
    }
    if (__items[index].l1cache) {
        [__items[index].l1cache release];
        __items[index].l1cache = nil;
    }
    if (__items[index].l2cache) {
        [__items[index].l2cache release];
        __items[index].l2cache = nil;
    }
    if (__items[index].filehandle) {
        [__items[index].filehandle closeFile];
        [__items[index].filehandle release];
        __items[index].filehandle = nil;
    }
    if (__items[index].datemodified) {
        [__items[index].datemodified release];
        __items[index].datemodified = nil;
    }
    if (__items[index].didFinishLoad) {
        [__items[index].didFinishLoad release];
        __items[index].didFinishLoad = nil;
    }
    __items[index].index = 0;
    __items[index].cancelable = 0;
    __items[index].canceled = 0;
    __items[0].index -= 1;
}

- (BOOL)cancelConnectionOfURLWithString:(NSString *)URLStr
{
    NSUInteger newHash = [URLStr hash];
    NSURLConnection *connection = nil;
    NSInteger i = 0;
    dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
    NSInteger count = __items[0].index;
    for (i = 1; i < MAXDOWNLOAD; i++)
    {
        if (count == 0)
            break;
        if (__items[i].index != 0)
        {
            count--;
            if (__items[i].urlstrhash == newHash)
            {
                __items[i].canceled = 1;
                __items[i].urlstrhash = 0;
                connection = (NSURLConnection *)__items[i].connection;
                break;
            }
        }
    }
    dispatch_semaphore_signal(__networkqueuesemaphore);
    if (connection)
    {
        NSFileHandle *fileHandle = nil;
        NSDate *dateModified = nil;
        NSString *l2Path = nil;
        pthread_mutex_lock(&__mutex_status);
        if (__items[i].cancelable == 1)
        {
            __items[i].connection = 0;
            [connection cancel];
            l2Path = [__items[i].l2cache retain];
            if (__items[i].filehandle)
            {
                fileHandle = [__items[i].filehandle retain];
            }
            if (__items[i].datemodified)
            {
                dateModified = [__items[i].datemodified retain];
            }
            [self emptyCanceledItemAtIndex:i];
        }
        pthread_mutex_unlock(&__mutex_status);
        if (dateModified)
        {
            if (fileHandle)
            {
                [fileHandle closeFile];
                [__fm setAttributes:@{NSFileModificationDate:dateModified} ofItemAtPath:l2Path error:nil];
                [fileHandle release];
            }
            [dateModified release];
        }
        else
        {
            if (fileHandle)
            {
                [fileHandle release];
            }
        }
        [l2Path release];
        return YES;
    }
    return NO;
}

- (NSString *)isDataLoadedFromURLWithString:(NSString *)URLStr
{
    NSString *filePath = [self fileSavePath:URLStr];
    if ([__fm fileExistsAtPath:filePath])
        return filePath;
    else
        return nil;
}

- (BOOL)emptyAllCaches
{
    dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
    if (__items[0].index != 0)
    {
        dispatch_semaphore_signal(__networkqueuesemaphore);
        return NO;
    }
    else
    {
        [__fm removeItemAtPath:_l2CacheDir error:nil];
        [__fm createDirectoryAtPath:_l2CacheDir withIntermediateDirectories:NO attributes:nil error:nil];
        dispatch_semaphore_signal(__networkqueuesemaphore);
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)l1cacheFilePathOfURLWithHash:(NSUInteger)hash
{
    unsigned long longVal = 0x0;
    NSString *fileName = [NSString stringWithFormat:@"/%lu.tmp", longVal | hash];
    NSString *path = [_l1CacheDir stringByAppendingString:fileName];
    return path;
}

- (NSString *)l2cacheFilePathOfURLWithHash:(NSUInteger)hash
{
    unsigned long longVal = 0x0;
    NSString *fileName = [NSString stringWithFormat:@"/%lu.ncf", longVal | hash];
    NSString *path = [_l2CacheDir stringByAppendingString:fileName];
    return path;
}

- (void)connectToDownloadItemAtIndex:(NSInteger)index
{
    dispatch_async(__networkconcurrentqueue, ^{
        NSURL *url = [NSURL URLWithString:__items[index].urlstr];
        NSURLRequest *ureq = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:ureq delegate:self];
        [ureq release];
        [connection setTag:0x0];
        [connection setIndex:index];
        __items[index].connection = (NSUInteger)connection;
        [connection start];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)continueToDownloadItemAtIndex:(NSInteger)index withRangeFrom:(unsigned long long)size urlHash:(NSUInteger)hash
{
    dispatch_async(__networkconcurrentqueue, ^{
        NSURL *url = [NSURL URLWithString:__items[index].urlstr];
        NSMutableURLRequest *mureq = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:3];
        [mureq setHTTPMethod:@"GET"];
        [mureq addValue:[NSString stringWithFormat:@"bytes=%llu-", size] forHTTPHeaderField:@"Range"];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:mureq delegate:self];
        [mureq release];
        [connection setTag:0x1];
        [connection setIndex:index];
        dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
        if (__items[index].canceled == 0 && __items[index].urlstrhash == hash)
        {
            __items[index].connection = (NSUInteger)connection;
            [connection start];
            [[NSRunLoop currentRunLoop] run];
        }
        dispatch_semaphore_signal(__networkqueuesemaphore);
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    __items[[connection index]].cancelable = 0;///!!!!!!!!!!!!!!!!
    if (__items[[connection index]].connection == (NSUInteger)connection)
    {
        NSLog(@"无法连接到 %@", [[[connection currentRequest] URL] absoluteString]);
        [self emptyItemAtIndex:[connection index]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"\nresponse = %@", response);
    if ([(NSHTTPURLResponse *)response statusCode] != 200)
    {
        [self emptyItemAtIndex:[connection index]];
        [connection cancel];
        return;
    }
    NSDictionary *httpHeadersDic = [(NSHTTPURLResponse *)response allHeaderFields];
    NSString *lastModified = [httpHeadersDic objectForKey:@"Last-Modified"];
    NSString *contentLength = [httpHeadersDic objectForKey:@"Content-Length"];
    NSDate *remoteFileDateModified = nil;
    if (lastModified)
        remoteFileDateModified = [__httpDateFormater dateFromString:lastModified];
    NSInteger connectionTag = [connection tag];
    NSInteger connectionIndex = [connection index];
    NSUInteger urlHash = __items[connectionIndex].urlstrhash;
    if (connectionTag == 0x0)
    {
        if (lastModified)
        {
            if ([__fm fileExistsAtPath:__items[connectionIndex].l2cache])
            {
                NSDictionary *localFileInfo = [__fm attributesOfItemAtPath:__items[connectionIndex].l2cache error:nil];
                if ([[localFileInfo fileModificationDate] compare:remoteFileDateModified] == NSOrderedSame)
                {
                    if ([contentLength longLongValue] == [localFileInfo fileSize])/**load l2 cache*/
                    {
                        [connection cancel];
                        /*
                         */
                        __items[connectionIndex].cancelable = 0;
                        if (__items[connectionIndex].connection == (NSUInteger)connection)
                        {
                            __block NSData *data = [NSData dataWithContentsOfFile:__items[connectionIndex].l2cache];
                            /*
                             */
                            if (data)
                            {
                                dispatch_sync(__mainqueue, ^{
                                    __items[connectionIndex].didFinishLoad(data);
                                });
                                [data writeToFile:__items[connectionIndex].l1cache atomically:YES];
                            }
                            [self emptyItemAtIndex:connectionIndex];
                        }
                        return;
                    }
                    else if ([contentLength longLongValue] > [localFileInfo fileSize])
                    {
                        __items[connectionIndex].connection = 0;
                        [connection cancel];
                        [self continueToDownloadItemAtIndex:connectionIndex withRangeFrom:[localFileInfo fileSize] urlHash:urlHash];
                        return;
                    }
                    else
                    {
                        [__fm removeItemAtPath:__items[connectionIndex].l2cache error:nil];
                    }
                }
                else
                {
                    [__fm removeItemAtPath:__items[connectionIndex].l2cache error:nil];
                }
                /**
                 NSDirectoryEnumerator *dirEnum = [__fm enumeratorAtPath:@""];
                 [dirEnum fileAttributes];
                 */
            }
            [__fm createFileAtPath:__items[connectionIndex].l2cache contents:nil attributes:nil];
        }
        else
        {
            if ([__fm fileExistsAtPath:__items[connectionIndex].l2cache])
            {
                [__fm removeItemAtPath:__items[connectionIndex].l2cache error:nil];
                [__fm createFileAtPath:__items[connectionIndex].l2cache contents:nil attributes:nil];
            }
            else
            {
                [__fm createFileAtPath:__items[connectionIndex].l2cache contents:nil attributes:nil];
            }
        }
    }
    else if (connectionTag == 0x1) {}
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:__items[connectionIndex].l2cache];
    dispatch_semaphore_wait(__networkqueuesemaphore, DISPATCH_TIME_FOREVER);
    if (__items[connectionIndex].canceled == 0 && __items[connectionIndex].connection == (NSUInteger)connection)
    {
        if (__items[connectionIndex].filehandle)
        {
            [__items[connectionIndex].filehandle release];
        }
        __items[connectionIndex].filehandle = [fileHandle retain];
        if (remoteFileDateModified)
        {
            if (__items[connectionIndex].datemodified)
            {
                [__items[connectionIndex].datemodified release];
            }
            __items[connectionIndex].datemodified = [remoteFileDateModified retain];
        }
    }
    dispatch_semaphore_signal(__networkqueuesemaphore);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (__items[[connection index]].filehandle)
    {
        [__items[[connection index]].filehandle seekToEndOfFile];
        [__items[[connection index]].filehandle writeData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger connectionIndex = [connection index];
    if (__items[connectionIndex].datemodified)
    {
        [__fm setAttributes:@{NSFileModificationDate:__items[connectionIndex].datemodified} ofItemAtPath:__items[connectionIndex].l2cache error:nil];
    }
    __items[connectionIndex].cancelable = 0;
    if (__items[connectionIndex].connection == (NSUInteger)connection)
    {
        __block NSData *data = [NSData dataWithContentsOfFile:__items[connectionIndex].l2cache];
        if (data)
        {
            dispatch_sync(__mainqueue, ^{
                __items[connectionIndex].didFinishLoad(data);
            });
            if ([__fm fileExistsAtPath:__items[connectionIndex].l1cache])
            {
                [__fm removeItemAtPath:__items[connectionIndex].l1cache error:nil];
                [data writeToFile:__items[connectionIndex].l1cache atomically:YES];
            }
            else
            {
                [data writeToFile:__items[connectionIndex].l1cache atomically:YES];
            }
        }
        [self emptyItemAtIndex:connectionIndex];
    }
}

# pragma mark Work about file's path&name

- (NSString *)fileSavePath:(NSString *)URLStr
{
    const char *urlstr = [URLStr UTF8String];
    unsigned long offset = 0;
    for (unsigned long i = strlen(urlstr); i > 0; i--)//strlen不包含'\0'，sizeof包含'\0'。
    {
        offset = i - 1;
        if (*(urlstr + offset) == '/') {
            break;
        }
    }
    if (offset < 7) {
        return nil;
    }
    const char *filename = urlstr + offset;//include '/'
    NSString *path = [_destDir stringByAppendingString:[NSString stringWithUTF8String:filename]];
    return path;
}

- (NSString *)fileSavePath:(NSString *)URLStr withIndex:(uint32_t)index
{
    const char *urlstr = [URLStr UTF8String];
    unsigned long urllen = strlen(urlstr);
    ///=========
    unsigned long offset = 0;
    for (unsigned long i = urllen; i > 0; i--)
    {
        offset = i - 1;
        if (*(urlstr + offset) == '/') {
            break;
        }
    }
    const char *fullname = urlstr + offset;//include '/'
    unsigned long fullnamelen = urllen - offset;
    ///=========
    unsigned long exoff = 0;
    for (unsigned long i = fullnamelen; i > 0; i--)
    {
        exoff = i - 1;
        if (*(fullname + exoff) == '.') {
            break;
        }
    }
    if (exoff == 0)
    {
        exoff = fullnamelen;//*(fullname + exoff) = '\0', which, means no extension name.
    }
    const char *extension = fullname + exoff;//include '.'
    unsigned long exnamelen = fullnamelen - exoff;
    ///=========
    char buffer[fullnamelen + 13];//(0)'\0', 2^32 - 1 = 4294967295
    for (int i = 0; i < exoff; i++)//*(fullname + extension) = '.'
    {
        buffer[i] = *(fullname + i);
    }
    //memcpy(buffer, fullname, exoff);
    /**-----------*/
    buffer[exoff] = '\0';
    /**-----------*/
    char buffer2[exnamelen + 13];
    sprintf(buffer2, "(%d)%s", index, extension);//(int) -> utf8 ??
    strcat(buffer, buffer2);
    
    NSString *path = [_destDir stringByAppendingString:[NSString stringWithUTF8String:buffer]];
    return path;
}

@end

const char *nsurlconnection_category_property_tag = "nsurlconnection_category_property_tag_1764";
const char *nsurlconnection_category_property_index = "nsurlconnection_category_property_index_1764";
@implementation NSURLConnection (NetWork_1764)

- (void)setTag:(NSInteger)tag
{
    objc_setAssociatedObject(self, nsurlconnection_category_property_tag, [NSNumber numberWithInteger:tag], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)tag
{
    NSNumber *value = objc_getAssociatedObject(self, nsurlconnection_category_property_tag);
    if (value)
    {
        return [value integerValue];
    }
    return 0;
}

- (void)setIndex:(NSInteger)index
{
    objc_setAssociatedObject(self, nsurlconnection_category_property_index, [NSNumber numberWithInteger:index], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)index
{
    NSNumber *value = objc_getAssociatedObject(self, nsurlconnection_category_property_index);
    if (value)
    {
        return [value integerValue];
    }
    return 0;
}

@end
