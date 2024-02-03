//
//  BackgroundImporter.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 10/01/24.
//

import Foundation
import SwiftData

actor BackgroundImporter {
    var modelContainer: ModelContainer
    var apods: [APOD]

    init(modelContainer: ModelContainer, apods: [APOD]) {
        self.modelContainer = modelContainer
        self.apods = apods
    }

    func backgroundInsert() throws {
        let modelContext = ModelContext(modelContainer)

        for apod in apods {
            modelContext.insert(apod)
        }
        try modelContext.save()
    }
}


