#import "CreativeKit.h"
#import <SCSDKCreativeKit/SCSDKCreativeKit.h>

@implementation CreativeKit {
    SCSDKSnapAPI *_scSdkSnapApi;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

-(id)init
{
    self = [super init];
    if(self)
    {
        if (!_scSdkSnapApi) {
            _scSdkSnapApi = [[SCSDKSnapAPI alloc] init];
            NSLog(@"hi");
        }
    }
    return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(shareSticker: (NSDictionary *)options
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"snapchat://"]]) {
        
        SCSDKSnapSticker *sticker;
        
        if (options[@"stickerFileUrl"]) {
            UIImage *stickerImage = [UIImage imageWithContentsOfFile:options[@"stickerFileUrl"]];
            sticker = [[SCSDKSnapSticker alloc] initWithStickerImage:stickerImage];
        } else if ( options[@"stickerUrl"]) {
            NSURL *stickerImageUrl = [NSURL URLWithString: options[@"stickerUrl"]];
            sticker = [[SCSDKSnapSticker alloc] initWithStickerUrl:stickerImageUrl isAnimated:NO];
        }
        
        /* Stickers to be used in Snap */
        // UIImage *stickerImage = /* Prepare a sticker image */;
        // SCSDKSnapSticker *sticker = [[SCSDKSnapSticker alloc] initWithStickerImage:stickerImage];
        /* Alternatively, use a URL instead */
        // SCSDKSnapSticker *sticker = [[SCSDKSnapSticker alloc] initWithStickerUrl:stickerImageUrl isAnimated:NO];

        /* Modeling a Snap using SCSDKNoSnapContent*/
        SCSDKNoSnapContent *snap = [[SCSDKNoSnapContent alloc] init];

        snap.sticker = sticker; /* Optional */

        if (options[@"caption"]) {
            snap.caption = options[@"caption"]; /* Optional */
        }

        if (options[@"swipeUpUrl"]) {
            snap.attachmentUrl = options[@"swipeUpUrl"];
        }

        [_scSdkSnapApi startSendingContent:snap completionHandler:^(NSError *error) {
            /* Handle response */
            if (error) {
                reject(@"error", error.localizedDescription, error);
            } else {
                resolve(@{@"result": @(YES)});
            }
        }];

        // [NSThread sleepForTimeInterval:1.0f];

    } else {
        // Cannot open snapchat
        NSString *stringURL = @"http://itunes.apple.com/app/snapchat/id447188370";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];

        // NSString *errorMessage = @"Not installed";
        // NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)};
        // NSError *error = [NSError errorWithDomain:@"com.rnshare" code:1 userInfo:userInfo];

        // failureCallback(error);
    }

}

@end
