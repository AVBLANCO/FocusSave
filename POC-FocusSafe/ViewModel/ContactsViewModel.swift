//
//  ContactsViewModel.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import Foundation
import Contacts
import SwiftUI

class ContactsViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var contactsGroupedByInitial: [String: [CNContact]] = [:]
    @Published var permissionDenied: Bool = false
    @Published var isLoading: Bool = false

    func requestPermission() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if granted {
                self?.fetchContacts()
            } else {
                self?.permissionDenied = true
            }
        }
    }

    private func fetchContacts() {
        isLoading = true
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            let contacts = try store.unifiedContacts(matching: CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier()), keysToFetch: keys as [CNKeyDescriptor])
            self.contacts = contacts
            self.groupContactsByInitial()
            isLoading = false
        } catch {
            print("Error fetching contacts: \(error)")
            isLoading = false
        }
    }

    private func groupContactsByInitial() {
        var groupedContacts: [String: [CNContact]] = [:]
        for contact in contacts {
            let initial = String(contact.givenName.prefix(1)).uppercased()
            if groupedContacts[initial] != nil {
                groupedContacts[initial]?.append(contact)
            } else {
                groupedContacts[initial] = [contact]
            }
        }
        contactsGroupedByInitial = groupedContacts
    }
}
