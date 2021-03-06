#import "LoginKit.h"
#import <SCSDKLoginKit/SCSDKLoginKit.h>

@implementation LoginKit

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(login,
                 loginResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    [SCSDKLoginClient loginFromViewController:rootViewController
                                   completion:^(BOOL success, NSError * _Nullable error)
    {
        if(error) {
            resolve(@{
                @"result": @(NO),
                @"error": error.localizedDescription
            });
        } else {
            resolve(@{@"result": @(YES)});
        }
    }];
}

RCT_REMAP_METHOD(logout,
                 logoutResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [SCSDKLoginClient clearToken];
}

RCT_REMAP_METHOD(isUserLoggedIn,
                 isUserLoggedInResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    
    resolve(@{@"result": @([SCSDKLoginClient isUserLoggedIn])});
}

RCT_REMAP_METHOD(fetchUserData,
                 fetchUserDataResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if ([SCSDKLoginClient isUserLoggedIn]) {
        NSString *graphQLQuery = @"{me{displayName, externalId, bitmoji{selfie, avatar}}}";
        
        NSDictionary *variables = @{@"page": @"bitmoji"};
        
        [SCSDKLoginClient fetchUserDataWithQuery:graphQLQuery
                                       variables:variables
                                         success:^(NSDictionary *resources)
        {
            NSDictionary *data = resources[@"data"];
            NSDictionary *me = data[@"me"];
            NSDictionary *bitmoji = me[@"bitmoji"];
            NSString *bitmojiSelfieUrl = bitmoji[@"selfie"];
            NSString *bitmojiAvatarUrl = bitmoji[@"avatar"];
            
            if (bitmojiAvatarUrl == (id)[NSNull null] || bitmojiAvatarUrl.length == 0 ) bitmojiAvatarUrl = @"";
            if (bitmojiSelfieUrl == (id)[NSNull null] || bitmojiSelfieUrl.length == 0 ) bitmojiSelfieUrl = @"";

            // not all users have bitmoji selfie
            if (bitmojiSelfieUrl == nil) {
                bitmojiSelfieUrl = @"";
            }
            
            // user can toggle off sharing bitmoji avatar
            if (bitmojiAvatarUrl == nil) {
                bitmojiAvatarUrl = @"";
            }
            
            resolve(@{
                @"displayName": me[@"displayName"],
                @"externalId": me[@"externalId"],
                @"selfie": bitmojiSelfieUrl,
                @"avatar": bitmojiAvatarUrl
            });
            
        }
        failure:^(NSError * error, BOOL isUserLoggedOut)
        {
            reject(@"error", error.localizedDescription, error);
        }];
    } else {
        resolve([NSNull null]);
    }
}

RCT_REMAP_METHOD(getAccessToken,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [SCSDKLoginClient refreshAccessTokenWithCompletion:^(NSString * _Nullable accessToken, NSError *_Nullable error) {
        if (accessToken) {
            resolve(@{
                @"accessToken": accessToken
            });
        } else {
            resolve(@{
                @"accessToken": [NSNull null],
                @"error": error
            });
        }
    }];
}

@end
