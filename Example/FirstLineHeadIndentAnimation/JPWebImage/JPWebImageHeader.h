//
//  JPWebImageHeader.h
//  webpTest
//
//  Created by 周健平 on 2018/8/27.
//  Copyright © 2018 周健平. All rights reserved.
//

/// The options to control image operation.
typedef NS_OPTIONS(NSUInteger, JPWebImageOptions) {
    
    /// Show network activity on status bar when download image.
    JPWebImageOptionShowNetworkActivity = 1 << 0,
    
    /// Display progressive/interlaced/baseline image during download (same as web browser).
    JPWebImageOptionProgressive = 1 << 1,
    
    /// Display blurred progressive JPEG or interlaced PNG image during download.
    /// This will ignore baseline image for better user experience.
    JPWebImageOptionProgressiveBlur = 1 << 2,
    
    /// Use NSURLCache instead of YYImageCache.
    JPWebImageOptionUseNSURLCache = 1 << 3,
    
    /// Allows untrusted SSL ceriticates.
    JPWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    
    /// Allows background task to download image when app is in background.
    JPWebImageOptionAllowBackgroundTask = 1 << 5,
    
    /// Handles cookies stored in NSHTTPCookieStore.
    JPWebImageOptionHandleCookies = 1 << 6,
    
    /// Load the image from remote and refresh the image cache.
    JPWebImageOptionRefreshImageCache = 1 << 7,
    
    /// Do not load image from/to disk cache.
    JPWebImageOptionIgnoreDiskCache = 1 << 8,
    
    /// Do not change the view's image before set a new URL to it.
    JPWebImageOptionIgnorePlaceHolder = 1 << 9,
    
    /// Ignore image decoding.
    /// This may used for image downloading without display.
    JPWebImageOptionIgnoreImageDecoding = 1 << 10,
    
    /// Ignore multi-frame image decoding.
    /// This will handle the GIF/APNG/WebP/ICO image as single frame image.
    JPWebImageOptionIgnoreAnimatedImage = 1 << 11,
    
    /// Set the image to view with a fade animation.
    /// This will add a "fade" animation on image view's layer for better user experience.
    JPWebImageOptionSetImageWithFadeAnimation = 1 << 12,
    
    /// Do not set the image to the view when image fetch complete.
    /// You may set the image manually.
    JPWebImageOptionAvoidSetImage = 1 << 13,
    
    /// This flag will add the URL to a blacklist (in memory) when the URL fail to be downloaded,
    /// so the library won't keep trying.
    JPWebImageOptionIgnoreFailedURL = 1 << 14,
};

/// Indicated where the image came from.
typedef NS_ENUM(NSUInteger, JPWebImageFromType) {
    
    /// No value.
    JPWebImageFromNone = 0,
    
    /// Fetched from memory cache immediately.
    /// If you called "setImageWithURL:..." and the image is already in memory,
    /// then you will get this value at the same call.
    JPWebImageFromMemoryCacheFast,
    
    /// Fetched from memory cache.
    JPWebImageFromMemoryCache,
    
    /// Fetched from disk cache.
    JPWebImageFromDiskCache,
    
    /// Fetched from remote (web or file path).
    JPWebImageFromRemote,
};

/// Indicated image fetch complete stage.
typedef NS_ENUM(NSInteger, JPWebImageStage) {
    
    /// Incomplete, progressive image.
    JPWebImageStageProgress  = -1,
    
    /// Cancelled.
    JPWebImageStageCancelled = 0,
    
    /// Finished (succeed or failed).
    JPWebImageStageFinished  = 1,
};

typedef void(^JPSetImageProgress)(float percent);
typedef UIImage *(^JPSetImageTransform)(UIImage *image, NSURL *imageURL);
typedef void(^JPSetImageCompleted)(UIImage *image, NSError *error, NSURL *imageURL, JPWebImageFromType jp_fromType, JPWebImageStage jp_stage);
