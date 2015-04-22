import Foundation

class Preference {
    var mintAPIKey: String {
        get {
            if let path = preferencePlistPath {
                if let dictionary = NSDictionary(contentsOfFile: path) {
                    return dictionary.objectForKey("MintAPIKey") as? String ?? ""
                }
            }
            return ""
        }
    }

    var preferencePlistPath: String? {
        get {
            return NSBundle.mainBundle().pathForResource("preference", ofType: "plist")
        }
    }
}