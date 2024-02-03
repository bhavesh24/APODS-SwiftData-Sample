//
//  APODRow.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 10/01/24.
//

import SwiftUI
import SwiftData

struct APODRow: View {
    let item: APOD
    let apodViewModel: APODViewModel
    @Environment(\.modelContext) private var context: ModelContext
    var body: some View {
        HStack() {
            if  let imageURLString = item.imageURL,
                let imageURL = URL(string: imageURLString) {
                if let image = apodViewModel.cache.object(forKey:imageURL as NSURL) {
                    Image(uiImage: image)
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 50, maxHeight: 50)
                } else {
                    AsyncImage(url:  imageURL, content: { image in
                        image
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 50, maxHeight: 50)
                        let _ = DispatchQueue.main.async {
                            apodViewModel.cache.setObject(image.snapshot(), forKey: imageURL as NSURL)
                        }
                    }, placeholder: {
                        ProgressView()
                    })
                }
            }
        }
        Text(item.title ?? "")
    }
}

#Preview {
    Text("")
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
