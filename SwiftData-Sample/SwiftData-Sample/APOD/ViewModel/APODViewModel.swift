//
//  APODViewModel.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 10/01/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor class APODViewModel: ObservableObject {
    var error: String?
    @Published var isLoading: Bool = true
    let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func getAPODS(context: ModelContext) async {
        do {
            let data = try await NetworkManager.shared().getData(queryParams: [QueryParams.count: "100"])
            let apodsDecoded = try JSONDecoder().decode([APOD].self, from: data)
            print(context.container.configurations.first?.url.path(percentEncoded: false) as Any)
            let bgImporter = BackgroundImporter(modelContainer: context.container, apods: apodsDecoded)
            try await bgImporter.backgroundInsert()
            isLoading = false
        } catch {
            self.error = error.localizedDescription
        }
    }
    
}
