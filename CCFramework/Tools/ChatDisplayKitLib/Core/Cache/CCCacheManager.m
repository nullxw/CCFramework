//
//  CCCacheManager.m
//  CCFramework
//
// Copyright (c) 2015 CC ( http://www.ccskill.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "CCCacheManager.h"
#import "CCFileAttribute.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"

@interface CCCacheManager () {
    NSCache *_memoryCache;
    NSString *_cacheDirectoryPath;
}

@property (nonatomic, strong) NSString *identifier;

@end

@implementation CCCacheManager

+ (instancetype)shareCacheManager {
    return self.manager;
}

+ (CCCacheManager *)cacheManagerWithIdentifier:(NSString *)identifier {
    return [[CCCacheManager alloc] initWithIdentifier:identifier];
}

- (id)init {
    return self.class.manager;
}

+ (CCCacheManager *)manager {
    static CCCacheManager *sharedInstance = nil;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCCacheManager alloc] initWithIdentifier:NSStringFromClass(self)];
    });
    return sharedInstance;
}

- (id)initWithIdentifier:(NSString *)identifier {
    if(identifier.length <= 0) {
        return self.class.manager;
    }

    self = [super init];
    if(self) {
        _memoryCache = [NSCache new];
        _memoryCache.countLimit = 50;
        self.identifier = identifier;
    }
    return self;
}

- (void)dealloc {
    [_memoryCache removeAllObjects];
}

#pragma mark- Uitility

+ (void)_checkWorkspace:(NSString*)rootDir
{
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:rootDir isDirectory:&isDirectory];

    if(!exists || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    }

    for(int i = 0; i < 16; i++) {
        for(int j = 0; j < 16; j++) {
            NSString *subDir = [NSString stringWithFormat:@"%@/%X%X", rootDir, i, j];
            isDirectory = NO;
            exists = [[NSFileManager defaultManager] fileExistsAtPath:subDir isDirectory:&isDirectory];
            if(!exists || !isDirectory) {
                [[NSFileManager defaultManager] createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
}

#pragma mark- directory operation

- (NSString *)_cacheDirectory {
    if(_cacheDirectoryPath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheDirectoryPath = [paths.lastObject stringByAppendingPathComponent:self.identifier.MD5Hash];
        [self.class _checkWorkspace:_cacheDirectoryPath];
    }

    return _cacheDirectoryPath;
}

- (NSArray *)_fileAttributesInWorkSpace {
    NSString *rootDir = self._cacheDirectory;
    NSMutableArray *files = [NSMutableArray array];

    for(int i = 0; i < 16; i ++) {
        for(int j = 0; j < 16; j++) {
            NSString *subDir = [NSString stringWithFormat:@"%@/%X%X", rootDir, i, j];
            NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:subDir error:nil];

            for(id name in list) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", subDir, name];
                NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                if(attr) {
                    [files addObject:[[CCFileAttribute alloc] initWithPath:filePath attributes:attr]];
                }
            }
        }
    }
    return files;
}

- (NSString *)_pathForHash:(NSString *)hash {
    return  [NSString stringWithFormat:@"%@/%@/%@", [self _cacheDirectory], [hash substringToIndex:2], hash];
}

#pragma mark- Caching control

- (void)limitNumberOfCacheFiles:(NSInteger)numberOfCacheFiles {
    NSArray *list = [self _fileAttributesInWorkSpace];

    NSSortDescriptor *dsc = [NSSortDescriptor sortDescriptorWithKey:@"fileModificationDate" ascending:NO];
    list = [list sortedArrayUsingDescriptors:@[dsc]];

    for(NSInteger i = numberOfCacheFiles; i < list.count; ++i) {
        CCFileAttribute *file = list[i];
        [[NSFileManager defaultManager] removeItemAtPath:file.filePath error:nil];
    }
}

- (void)_didAccessToDataForHash:(NSString *)hash {
    NSString *path = [self _pathForHash:hash];

    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *fileAttribute = [[fileManager attributesOfItemAtPath:path error:&err] mutableCopy];

    if(err) { return; }

    fileAttribute[NSFileModificationDate] = [NSDate date];
    [fileManager setAttributes:fileAttribute ofItemAtPath:path error:nil];
}

- (void)removeCacheForURL:(NSURL *)url {
    if(url.absoluteString.length > 0){
        [self _removeCacheForHash:url.absoluteString.MD5Hash];
    }
}

- (void)_removeCacheForHash:(NSString *)hash {
    [_memoryCache removeObjectForKey:hash];

    [[NSFileManager defaultManager] removeItemAtPath:[self _pathForHash:hash] error:nil];
}

- (void)removeCacheDirectory {
    [_memoryCache removeAllObjects];
    [[NSFileManager defaultManager] removeItemAtPath:[self _cacheDirectory] error:nil];

    _cacheDirectoryPath = nil;
}

- (unsigned long long)diskSize {
    long long diskSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:[self _cacheDirectory] error:&error];
    if (!contents) {
        NSLog(@"Failed to list directory with error %@", error);
        return diskSize;
    }
    for (NSString *pathComponent in contents) {
        NSString *path = [[self _cacheDirectory] stringByAppendingPathComponent:pathComponent];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
        if (!attributes) continue;

        diskSize += attributes.fileSize;
    }
    return diskSize;
}

#pragma mark- NSData caching

- (void)storeData:(NSData *)data forURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    if(data && url.absoluteString.length > 0) {
        [self _storeData:data forHash:url.absoluteString.MD5Hash storeMemoryCache:storeMemoryCache];
    }
}

- (void)_storeData:(NSData *)data forHash:(NSString *)hash storeMemoryCache:(BOOL)storeMemoryCache {
    [self _didAccessToDataForHash:hash];

    if(storeMemoryCache) {
        [_memoryCache setObject:data forKey:hash];
    }
    [data writeToFile:[self _pathForHash:hash] atomically:NO];
}

- (NSData *)localCachedDataWithURL:(NSURL *)url {
    if(url.absoluteString.length > 0){
        return [self _localCachedDataWithHash:url.absoluteString.MD5Hash];
    }
    return nil;
}

- (NSData *)_localCachedDataWithHash:(NSString *)hash {
    [self _didAccessToDataForHash:hash];
    return [NSData dataWithContentsOfFile:[self _pathForHash:hash]];
}

- (NSData *)_cachedDataWithHash:(NSString *)hash storeMemoryCache:(BOOL)storeMemoryCache {
    NSData   *data = [_memoryCache objectForKey:hash];
    if(data){
        [self _didAccessToDataForHash:hash];
        return data;
    }

    data = [self _localCachedDataWithHash:hash];
    if(storeMemoryCache && data!=nil) {
        [_memoryCache setObject:data forKey:hash];
    }
    return data;
}

- (NSData *)dataWithURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    if(url.absoluteString.length == 0) {
        return nil;
    }
    return [self _cachedDataWithHash:url.absoluteString.MD5Hash storeMemoryCache:storeMemoryCache];
}

- (BOOL)existsDataForURL:(NSURL *)url {
    if(url.absoluteString.length > 0) {
        NSString *path = [self _pathForHash:url.absoluteString.MD5Hash];

        BOOL isDirectory = YES;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];

        return (exists && !isDirectory);
    }
    return NO;
}

#pragma mark- UIImage caching

- (void)storeMemoryCacheWithImage:(UIImage *)image forURL:(NSURL *)url {
    if(image && url.absoluteString.length > 0) {
        [self storeMemoryCacheWithImage:image forHash:url.absoluteString.MD5Hash];
    }
}

- (void)storeMemoryCacheWithImage:(UIImage *)image forHash:(NSString *)hash {
    [_memoryCache setObject:image forKey:hash];
}

- (UIImage *)imageWithURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    if(url.absoluteString.length == 0) {
        return nil;
    }

    id data = [self dataWithURL:url storeMemoryCache:NO];

    if(data) {
        UIImage *image = nil;

        if([data isKindOfClass:[NSData class]]) {
            image = [UIImage fastImageWithData:data];
        } else if([data isKindOfClass:[UIImage class]]) {
            image = (UIImage*)data;
        }

        if(image) {
            if(storeMemoryCache){
                [self storeMemoryCacheWithImage:image forURL:url];
            }
            return image;
        }
    }
    return nil;
}

#pragma mark- wrapper

+ (void)limitNumberOfCacheFiles:(NSInteger)numberOfCacheFiles {
    [self.manager limitNumberOfCacheFiles:numberOfCacheFiles];
}

+ (void)removeCacheForURL:(NSURL *)url {
    [self.manager removeCacheForURL:url];
}

+ (void)removeCacheDirectory {
    [self.manager removeCacheDirectory];
}

+ (unsigned long long)diskSize {
    return [self.manager diskSize];
}

+ (void)storeData:(NSData *)data forURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    [self.manager storeData:data forURL:url storeMemoryCache:storeMemoryCache];
}

+ (NSData *)localCachedDataWithURL:(NSURL *)url {
    return [self.manager localCachedDataWithURL:url];
}

+ (NSData *)dataWithURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    return [self.manager dataWithURL:url storeMemoryCache:storeMemoryCache];
}

+ (void)storeMemoryCacheWithImage:(UIImage*)image forURL:(NSURL*)url {
    [self.manager storeMemoryCacheWithImage:image forURL:url];
}

+ (UIImage *)imageWithURL:(NSURL *)url storeMemoryCache:(BOOL)storeMemoryCache {
    return [self.manager imageWithURL:url storeMemoryCache:storeMemoryCache];
}

+ (BOOL)existsDataForURL:(NSURL *)url {
    return [self.manager existsDataForURL:url];
}

@end
