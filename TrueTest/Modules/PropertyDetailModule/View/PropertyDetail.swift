//
//  PropertyDetail.swift
//  REO
//
//  Created by Amir on 8/28/1400 AP.
//

import SwiftUI
import Core
import Combine

struct PropertyDetailView: View {
    
    // MARK: - Property
    
    @State private var state: ViewState = .init(image: nil, title: "", price: nil, address: nil)
    var publisher: AnyPublisher<ViewState, Never>
    let viewAction: (PropertyDetailView.ViewAction) -> Void
    
    // MARK: - View
    
    var body: some View {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: state.image) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.width * 9/16 )
                            .background(Color.gray)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.width * 9/16 )
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    
                    
                    if state.price != nil {
                        makeRow(title: "Price", value: state.price!)
                    }
                    
                    if state.address != nil {
                        makeRow(title: "Address", value: state.address!)
                    }
                }.frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .navigationTitle(state.title)
            }.onReceive(publisher) { ViewState in
                state = ViewState
            }
            .padding(16)
    }
    
    @ViewBuilder
    func makeRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text(title)
                .foregroundColor(.gray)
                .frame(width: 70, alignment: .leading)
            Text(value)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

extension PropertyDetailView {
    struct ViewState: Equatable {
        let image: URL?
        let title: String
        let price: String?
        let address: String?
    }
    enum ViewAction {}
}


struct PropertyDetail_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(
            publisher: Just(PropertyDetailView.ViewState.init(image: nil, title: "Test", price: "Test", address: "Test")).eraseToAnyPublisher()
        )
        { action in
            print(action)
        }
    }
}
