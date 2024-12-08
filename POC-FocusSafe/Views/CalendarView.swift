//
//  CalendarView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some View {
        List(viewModel.events, id: \.eventIdentifier) { event in
            VStack(alignment: .leading) {
                Text(event.title)
                Text(event.startDate, style: .date)
            }
        }
        .onAppear {
            viewModel.requestPermission()
        }
        .navigationTitle("Calendario")
    }
}
