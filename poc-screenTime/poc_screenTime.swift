//
//  poc_screenTime.swift
//  poc-screenTime
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import DeviceActivity
import SwiftUI

@main
struct poc_screenTime: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
