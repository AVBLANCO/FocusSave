//
//  ContactsView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI
import Contacts

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel()

    var body: some View {
        ZStack {
            if viewModel.permissionDenied {
                Text("Permiso de contactos denegado.")
                    .foregroundColor(.red)
            } else {
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        List {
                            ForEach(viewModel.contactsGroupedByInitial.keys.sorted(), id: \.self) { initial in
                                Section(header: CircleTextView(text: initial)) {
                                    if let contacts = viewModel.contactsGroupedByInitial[initial] {
                                        ForEach(contacts) { contact in
                                            ContactRowView(contact: contact)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 170)
                .onAppear {
                    viewModel.requestPermission()
                }
            }
        }
        .navigationTitle("Contactos")
    }
}

struct ContactsSectionView: View {
    var contacts: [CNContact]

    var body: some View {
        ForEach(contacts) { contact in
            ContactRowView(contact: contact)
                .padding(.vertical, 5)
        }
    }
}

struct ContactRowView: View {
    var contact: CNContact

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(contact.givenName) \(contact.familyName)")
                if let phone = contact.phoneNumbers.first?.value.stringValue {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: {
                callContact()
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
            }
        }
    }

    private func callContact() {
        if let phone = contact.phoneNumbers.first?.value.stringValue {
            if let url = URL(string: "tel://\(phone)") {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct CircleTextView: View {
    let text: String

    var body: some View {
        Text(text)
            .frame(width: 40, height: 40)
            .background(Color.gray)
            .clipShape(Circle())
            .foregroundColor(.black)
    }
}
