//
//  PropertyItem.swift
//  REO
//
//  Created by Amir on 8/27/1400 AP.
//

import SwiftUI
import Core

struct PropertyItem: View {
    var item: Property
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage.init(url: item.imageURL, scale: 1) { image in
                image
                    .frame(width: 64, height: 64, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 64, height: 64, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            }

            
            Text(item.title)
                .lineLimit(1)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

extension PropertyItem {
    struct Property: Equatable, Identifiable {
        var id: String
        var title: String
        var imageURL: URL?
    }
}

extension PropertyItem.Property {
    init(property: Property) {
        self.id = property.id
        self.imageURL = property.image
        self.title = property.title
    }
    
    static var stub: PropertyItem.Property {
        .init(id: UUID.init().uuidString, title: "Amir", imageURL: URL.init(string: "https://picsum.photos/100/100"))
    }
}
struct PropertyItem_Previews: PreviewProvider {
    static var previews: some View {
        PropertyItem(item: .stub)
    }
}
