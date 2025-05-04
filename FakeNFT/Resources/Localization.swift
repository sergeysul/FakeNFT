import Foundation

enum Localization {
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    // MARK: - Tab Bar
    static let catalogTab = localized("Tab.catalog")

    // MARK: - Catalog
    static let openNft = localized("Catalog.openNft")

    // MARK: - Errors
    static let networkError = localized("Error.network")
    static let unknownError = localized("Error.unknown")
    static let repeatAction = localized("Error.repeat")
    static let errorTitle = localized("Error.title")

    // MARK: - Filters
    static let filterTableTitle = localized("Filter.table.title")
    static let filterChoiceRating = localized("Filter.choice.rating")
    static let filterChoiceName = localized("Filter.choice.name")
    static let filterChoicePrice = localized("Filter.choice.price")

    // MARK: - Common
    static let close = localized("Close")

    // MARK: - Delete NFC Confirmation
    static let deleteNftConfirmationLabel = localized("DeleteNfc.confirmation.label")
    static let delete = localized("Delete")
    static let getBack = localized("GetBack")
    static let price = localized("Price")

    // MARK: - Agreement
    static let agreementTextLabel = localized("Agreement.textLabel")
    static let agreementLinkLabel = localized("Agreement.linkLabel")

    // MARK: - Payment
    static let pay = localized("Pay")
    static let paymentPageTitle = localized("PaymentPage.title")
}
