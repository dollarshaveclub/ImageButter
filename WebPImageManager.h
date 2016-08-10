//
//  WebPImageManager.h
//  ImageButter
//
//  Created by Dalton Cherry on 9/1/15.
//

#import <Foundation/Foundation.h>
#import "WebPImage.h"

typedef void (^WebPImageFinished)(WebPImage*);
typedef void (^WebPImageProgress)(CGFloat);
typedef void (^WebPPreloadFinished)(BOOL);

@interface WebPImageManager : NSObject

/**
 Singleton to share webp image access.
 */
+ (instancetype)sharedManager;

/**
 The time to cache an image on disk. The default is 24 hours.
 */
@property(nonatomic)NSInteger maxCacheAge;

/**
 Get an image for a url (on disk or remotely)
 @param url is the location to fetch the image from.
 @param progress is the block that reports how the total progress length. This is decode time of the image + network request if required.
 @param finished is the block that reports once the image is done being fetch,cached, and decoded (it is ready to be displayed).
 @return a sessionId to identify this specific session of closures. Is to be used for cancellation if needed.
 */
- (NSInteger)imageForUrl:(NSURL*)url progress:(WebPImageProgress)progress finished:(WebPImageFinished)finished;

/**
 "cancel" an image so the caller will no longer get the block callbacks.
 @param the session id returned from imageForUrl.
 @param the url that was orginally requested.
 */
- (void)cancelImageForSession:(NSInteger)session url:(NSURL*)url;

/**
 Clears the in memory cache
 */
- (void)clearCache;

/**
 Clears the in memory cache for a specific url.
 */
- (void)clearUrlFromCache:(NSURL*)url;

/**
 Cleans the cache directory of old files.
 This runs on a background thread, so it is recommend to run on each launch of your app.
 */
- (void)cleanDisk;

/**
 Just checks the in memory cache for an image.
 @param the url is used to check the in memory cache since images are cached and stored based on their urls.
 */
- (WebPImage*)imageFromCache:(NSURL*)url;

/**
 Preloads the image by downloading the image straight to disk instead of putting it in memory.
 @param the url is used to check the in memory cache since images are cached and stored based on their urls.
 @param finished is the block that reports once the image is done being fetch and cached to disk.
 */
- (void)preloadImage:(NSURL*)url finished:(WebPPreloadFinished)finished;

@end
