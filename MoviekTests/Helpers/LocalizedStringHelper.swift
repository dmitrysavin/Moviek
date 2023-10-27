
import Foundation

func localizedString(_ key: String) -> String {
    NSLocalizedString(key, bundle: Bundle(identifier: "com.test.Moviek")!, comment: "")
}
