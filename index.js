import { NativeModules, NativeEventEmitter } from "react-native";
const { LoginKit } = NativeModules;

export const NativeLoginKit = NativeModules.SnapchatLogin;
export const LoginKitEmitter = new NativeEventEmitter(NativeLoginKit);

class RNLoginKit {
  static async login() {
    try {
      let result = await LoginKit.login();
      if (result.error) {
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

class RNCreativeKit {}

class RNBitmojiKit {}

exports.LoginKit = RNLoginKit;
exports.CreativeKit = RNCreativeKit;
exports.BitmojiKit = RNBitmojiKit;
