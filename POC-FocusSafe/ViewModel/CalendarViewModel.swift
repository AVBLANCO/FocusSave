//
//  CalendarViewModel.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import EventKit
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var events: [EKEvent] = []
    @Published var permissionDenied = false
    private let eventStore = EKEventStore()

    func requestPermission() {
        eventStore.requestAccess(to: .event) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self.loadEvents()
                } else {
                    self.permissionDenied = true
                }
            }
        }
    }

    private func loadEvents() {
        let calendars = eventStore.calendars(for: .event)
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)

        events = eventStore.events(matching: predicate)
    }
}
