import PropTypes from "prop-types";
import React from "react";
import {
  NativeModules,
  NativeEventEmitter,
  requireNativeComponent,
} from "react-native";

const { LoginKit, CreativeKit } = NativeModules;

class BitmojiStickerPicker extends React.Component {
  render() {
    return <BitmojiStickerPickerNative {...this.props} />;
  }
}

BitmojiStickerPicker.propTypes = {
  /**
   * A Boolean value that determines whether the user may use pinch
   * gestures to zoom in and out of the map.
   */
  zoomEnabled: PropTypes.bool,
};

const BitmojiStickerPickerNative = requireNativeComponent(
  "BitmojiStickerPicker"
);
// export const NativeLoginKit = NativeModules.SnapchatLogin;
// export const LoginKitEmitter = new NativeEventEmitter(NativeLoginKit);

class RNLoginKit {
  static async login() {
    try {
      console.log("Attempting to login");
      let result = await LoginKit.login();
      if (result.error) {
        console.log(result.error, "error");
        throw new Error(result.error);
      }
      return await this.getUserInfo();
    } catch (error) {
      throw error;
    }
  }

  static async isLoggedIn() {
    const { result } = await LoginKit.isUserLoggedIn();
    return result;
  }

  static async logout() {
    const { result } = await LoginKit.logout();
    return result;
  }

  static async refreshAccessToken() {
    const { result } = await LoginKit.getAccessToken();
    return result;
  }

  static async getUserInfo() {
    try {
      let tmp = await LoginKit.fetchUserData();
      const data = tmp;
      if (data === null) {
        throw new Error("No User Info");
      }
      const res = await LoginKit.getAccessToken();
      data.accessToken = res.accessToken;
      return data;
    } catch (error) {
      throw error;
    }
  }
}

class RNCreativeKit {
  static async shareSticker(options) {
    // options: stickerUrl, swipeUpUrl, caption
    const { result } = await CreativeKit.shareSticker(options);
    return result;
  }
}

class RNBitmojiKit {}

exports.LoginKit = RNLoginKit;
exports.CreativeKit = RNCreativeKit;
exports.BitmojiKit = RNBitmojiKit;
exports.BitmojiStickerPicker = BitmojiStickerPicker;
