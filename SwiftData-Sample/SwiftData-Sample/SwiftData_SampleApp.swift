//
//  SwiftData_SampleApp.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 09/01/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftData_SampleApp: App {
    var body: some Scene {
        WindowGroup {
            APODView()
        }
        .modelContainer(for: APOD.self)
    }
}
