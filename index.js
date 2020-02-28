import { NativeModules } from "react-native";
const { LoginKit, CreativeKit, BitmojiKit } = NativeModules;

class LoginKit {
  login = async function() {
    try {
      await LoginKit.login();
    } catch (error) {
      throw error;
    }
  };
}

class CreativeKit {}

class BitmojiKit {}

exports.LoginKit = LoginKit;
exports.CreativeKit = CreativeKit;
exports.BitmojiKit = BitmojiKit;
