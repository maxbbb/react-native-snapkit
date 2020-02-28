#import <SCSDKLoginKit/SCSDKLoginKit.h>

// This might be the wrong way to pass in paraments, don't think first one gets a name
RCT_EXPORT_METHOD(login: 
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject
)
{
    id completionBlock = ^(BOOL success, NSError *error) {
        if (error) {
            // return [RNFBFirestoreCommon promiseRejectFirestoreException:reject error:error];
        } else {
            resolve(nil);
        }
    };

   ret = [SCSDKLoginClient loginFromViewController:viewController completion:completionBlock];

}

RCT_EXPORT_METHOD(clearToken)
{
    [SCSDKLoginKit clearToken];
}

RCT_EXPORT_METHOD(fetchUserData: 
 (NSString *) graphQLQuery
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject
)
{
// NSString *graphQLQuery = @"{me{bitmoji{selfie}}}";

id successBlock = ^(NSDictionary *resources) {
    // NSString *bitmojiSelfieUrl = resources[@"data"][@"me"][@"bitmoji"][@"selfie"];
    return resources;
};

id failureBlock = ^(NSError *error, BOOL isUserLoggedOut) {
    if (error) {
        if (isUserLoggedOut) {

        } else {

        }
        // return [RNFBFirestoreCommon promiseRejectFirestoreException:reject error:error];
    } else {
        resolve(nil);
    }
};

[SCSDKLoginClient fetchUserDataWithQuery
    :graphQLQuery
    variables: nil
    success: successBlock
    failure: failureBlock
];
}



