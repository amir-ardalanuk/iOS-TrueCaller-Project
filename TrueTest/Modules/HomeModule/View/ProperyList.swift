//
//  ProperyList.swift
//  REO
//
//  Created by Amir on 8/27/1400 AP.
//

import SwiftUI
import Core
import Resolver
import Combine

struct ProperyListView: View {
    
    // MARK: - Property
    
    @State private var state: ViewState = .init(items: [], isLoading: false)
    var publisher: AnyPublisher<ViewState, Never>
    let viewAction: (ProperyListView.ViewAction) -> Void
    
    // MARK: - View Builder
    
    var body: some View {
            VStack {
                ScrollView {
                    VStack {
                        LazyVStack(spacing: 8) {
                            ForEach(state.items) { item in
                                Button {
                                    didTapOn(property: item)
                                } label: {
                                    PropertyItem(item: item)
                                }.buttonStyle(PlainButtonStyle())
                            }
                            
                            Rectangle()
                                .frame(width: 1, height: 1)
                                .onAppear {
                                    viewAction(.fetch)
                                }
                        }
                    }
                }
                if state.isLoading {
                    ProgressView()
                }
            }
        .navigationTitle("Propertis")
        .padding(16.0)
        .onReceive(publisher) { ViewState in
            state = ViewState
        }
    }
    
    func didTapOn(property: PropertyItem.Property) {
        self.viewAction(.didSelect(id: property.id))
    }
    
}

// MARK: - View State and Action

extension ProperyListView {
    struct ViewState: Equatable {
        let items: [PropertyItem.Property]
        let isLoading: Bool
    }
    
    enum ViewAction {
        case fetch
        case error
        case didSelect(id: String)
    }
}

struct ProperyList_Previews: PreviewProvider {
    static var makeViewData: ViewData {
        let viewData = HomeViewData()
        let viewModel = DefaultHomeViewModel()
        Resolver.register(name: viewData.resolverName) { viewModel as HomeViewModel }
        return viewData
        
    }
    
    static var previews: some View {
        NavigationView {
            ProperyListView(
                publisher: Just(ProperyListView.ViewState(items: [.stub], isLoading: false))
                    .eraseToAnyPublisher()
            ) { action in
            }
        }
        
    }
}
