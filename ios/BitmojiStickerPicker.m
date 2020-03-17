#import "BitmojiStickerPicker.h"
#import <MapKit/MapKit.h>
#import <React/RCTViewManager.h>

// #import <SCSDKBitmojiKit/SCSDKBitmojiKit.h>

@implementation BitmojiStickerPicker

RCT_EXPORT_MODULE(BitmojiStickerPicker)

- (UIView *)view
{
  return [[MKMapView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(zoomEnabled, BOOL)

@end

