//
//  EditView.swift
//  BucketList
//
//  Created by surya sai on 02/06/24.
//

import SwiftUI

struct EditView: View {
    enum LoadingSate{
        case loading,loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel:ViewModel
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Name",text: $viewModel.name)
                    TextField("Description",text: $viewModel.description)
                }
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages,id: \.pageid) {page in
                            
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                            
                            
                            
                        }
                    case .failed:
                        Text("Please try again later")
                    }
                }
                
            }
            .navigationTitle("Place Details")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Delete Place") {
                        viewModel.onDelete(viewModel.location)
                        dismiss()
                        
                        
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                    HStack {
                        
                        Button("Dismiss") {
                            
                            dismiss()
                            
                            
                        }
                        
                        Button("Save") {
                            var newLocation = viewModel.location
                            newLocation.name = viewModel.name
                            newLocation.descriptor = viewModel.description
                            
                            viewModel.onSave(newLocation)
                            dismiss()
                        }
                        
                    }
                }
                
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
        
        
        
    }
    init(location:Location,onSave: @escaping (Location)->Void, onDelete: @escaping  (Location)->Void) {
        viewModel = ViewModel(location: location, onSave: onSave, onDelete: onDelete)
    }
    func fetchNearbyPlaces() async  {
       await viewModel.fetchNearbyPlaces()
                
    }
}

#Preview {
    EditView(location: Location(id: UUID(), name: "Apple Park", descriptor: "HeadQuaters", latitude: 37.334606, longitude: -122.009102)) {_ in} onDelete: {_ in}
}
