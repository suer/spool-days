import Foundation

class I18n {
    class func translate(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    class var yes: String { return I18n.translate("Yes") }

    class var no: String { return I18n.translate("No") }

    class var save: String { return I18n.translate("Save") }

    class var cancel: String { return I18n.translate("Cancel") }

    class var delete: String { return I18n.translate("Delete") }

    class var finish: String { return I18n.translate("Finish") }

    class var edit: String { return I18n.translate("Edit") }

    class var reset: String { return I18n.translate("Reset") }

    class var create: String { return I18n.translate("Create") }

    class var history: String { return I18n.translate("History") }

    class var confirmation: String { return I18n.translate("Confirmation") }
}