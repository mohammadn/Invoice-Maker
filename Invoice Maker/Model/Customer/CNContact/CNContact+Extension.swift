/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Extends the contact class.
 */

import Contacts

extension CNContact {
    var formattedName: String {
        CNContactFormatter().string(from: self) ?? "Unknown contact"
    }

    var initials: String {
        String(givenName.prefix(1) + familyName.prefix(1))
    }

    var phone: String? {
        phoneNumbers.first?.value.stringValue
    }

    var email: String? {
        emailAddresses.first?.value.description
    }

    var address: String? {
        guard let postalAddress = postalAddresses.first?.value else { return nil }

        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
    }
}
