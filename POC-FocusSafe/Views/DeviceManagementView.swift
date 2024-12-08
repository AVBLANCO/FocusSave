//
//  DeviceManagementView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 8/11/24.
//

import SwiftUI

struct DeviceManagementView: View {
    @State private var batteryLevel: Float = SystemManager.getBatteryLevel()
    @State private var batteryState: UIDevice.BatteryState = SystemManager.getBatteryState()
    @State private var screenWidth: CGFloat = SystemManager.getDeviceScreenWidth()
    @State private var screenHeight: CGFloat = SystemManager.getDeviceScreenHeight()
    @State private var systemVersion: String = SystemManager.getSystemVersion()
    @State private var orientation: UIDeviceOrientation = SystemManager.getDeviceOrientation()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Group {
                    Text("Device Information")
                        .font(.title)
                        .padding(.top)

                    DeviceInfoRow(label: "Device Name:", value: SystemManager.getiPhoneName())
                    DeviceInfoRow(label: "App Version:", value: SystemManager.getAPPVerion())
                    DeviceInfoRow(label: "System Name:", value: SystemManager.getSystemName())
                    DeviceInfoRow(label: "System Version:", value: systemVersion)
                    DeviceInfoRow(label: "Device UUID:", value: SystemManager.getUUID())
                }

                Divider()

                Group {
                    Text("Screen Information")
                        .font(.title)

                    DeviceInfoRow(label: "Screen Width:", value: "\(screenWidth) pts")
                    DeviceInfoRow(label: "Screen Height:", value: "\(screenHeight) pts")
                }

                Divider()

                Group {
                    Text("Battery Information")
                        .font(.title)

                    DeviceInfoRow(label: "Battery Level:", value: "\(batteryLevel * 100)%")
                    DeviceInfoRow(label: "Battery State:", value: batteryStateDescription(batteryState))
                }

                Divider()

                Group {
                    Text("System Information")
                        .font(.title)

                    DeviceInfoRow(label: "Total Memory Size:", value: "\(SystemManager.getTotalMemorySize()) bytes")
                    DeviceInfoRow(label: "Processor Count:", value: "\(SystemManager.getProcessorCount())")
                    DeviceInfoRow(label: "Active Processor Count:", value: "\(SystemManager.getActiveProcessorCount())")
                    DeviceInfoRow(label: "Current Language:", value: SystemManager.getDeviceLanguage())
                    DeviceInfoRow(label: "Orientation:", value: orientationDescription(orientation))
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            // Actualizar la información del dispositivo al cargar la vista
            refreshDeviceInfo()
        }
        .navigationBarTitle("Device Management", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: refreshDeviceInfo) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title2)
                }
            }
        }
    }

    // Actualizar la información del dispositivo
    private func refreshDeviceInfo() {
        batteryLevel = SystemManager.getBatteryLevel()
        batteryState = SystemManager.getBatteryState()
        screenWidth = SystemManager.getDeviceScreenWidth()
        screenHeight = SystemManager.getDeviceScreenHeight()
        systemVersion = SystemManager.getSystemVersion()
        orientation = SystemManager.getDeviceOrientation()
    }

    // Descripción del estado de la batería
    private func batteryStateDescription(_ state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown: return "Unknown"
        case .unplugged: return "Unplugged"
        case .charging: return "Charging"
        case .full: return "Full"
        @unknown default: return "Unknown"
        }
    }

    // Descripción de la orientación del dispositivo
    private func orientationDescription(_ orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait Upside Down"
        case .landscapeLeft: return "Landscape Left"
        case .landscapeRight: return "Landscape Right"
        case .faceUp: return "Face Up"
        case .faceDown: return "Face Down"
        default: return "Unknown"
        }
    }
}

struct DeviceInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}


class SystemManager {

    /// Get Screen Width
    static func getDeviceScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    /// Get Screen Height
    static func getDeviceScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    /// Get iPhone Nick Name
    static func getiPhoneName() -> String {
        return UIDevice.current.name
    }

    /// Get App Version Number
    static func getAPPVerion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// Get Battery Level
    static func getBatteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }

    /** Get Battery State
    1. unknown
    2. unplugged // on battery, discharging
    3. charging // plugged in, less than 100%
    4. full // plugged in, at 100%
    */
    static func getBatteryState() -> UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }

    /// Get System Name
    static func getSystemName() -> String {
        return UIDevice.current.systemName
    }

    /// Get Current System Version Number
    static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /** Get Device Orientation
    1. unknown
    2. portrait // Device oriented vertically, home button on the bottom
    3. portraitUpsideDown // Device oriented vertically, home button on the top
    4. landscapeLeft // Device oriented horizontally, home button on the right
    5. landscapeRight // Device oriented horizontally, home button on the left
    6. faceUp // Device oriented flat, face up
    7. faceDown // Device oriented flat, face down
    */
    static func getDeviceOrientation() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    /// Get Device UUID
    static func getUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    /// Get Memory Size
    static func getTotalMemorySize() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }

    /// Get Processor Count
    static func getProcessorCount() -> Int {
        return ProcessInfo.processInfo.processorCount
    }

    /// Get Active Processor Count
    static func getActiveProcessorCount() -> Int {
        return ProcessInfo.processInfo.activeProcessorCount
    }

    /// Get Current Device Language
    static func getDeviceLanguage() -> String {
        let languageArray: [String] = NSLocale.preferredLanguages
        return languageArray.first ?? ""
    }
}
