//
//  ContentView.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 09/01/24.
//

import SwiftUI
import SwiftData

struct APODView: View {
    @StateObject var apodViewModel = APODViewModel()
    @Environment(\.modelContext) private var context: ModelContext
    @Query var apods: [APOD] = []
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(apods) { item in
                        NavigationLink(value: item) {
                            APODRow(item: item, apodViewModel: apodViewModel)
                        }
                    }
                }.navigationTitle("APODS")
                    .task {
                        if apods.count == 0 {
                            await apodViewModel.getAPODS(context: context)
                        }
                    }
                if apodViewModel.isLoading && apods.count == 0 {
                    ProgressView()
                }
            }
        }
    }
    
}

#Preview {
    APODView()
}
