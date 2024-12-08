//
//  CallManager.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 8/11/24.
//

import Foundation
import CallKit

class CallManager: NSObject, CXProviderDelegate {
    let provider: CXProvider

    override init() {
        let configuration = CXProviderConfiguration(localizedName: "App Focus Safe")
        configuration.supportsVideo = false
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.phoneNumber]

        provider = CXProvider(configuration: configuration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    func providerDidReset(_ provider: CXProvider) {
        // Restablecimiento del proveedor de llamadas
    }
}
