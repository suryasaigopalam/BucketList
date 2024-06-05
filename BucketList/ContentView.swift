//
//  ContentView.swift
//  BucketList
//
//  Created by surya sai on 24/05/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.334606, longitude: -122.009102), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    )
    @State var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack(alignment:.bottomTrailing) {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) {location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44,height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedLocation = location
                                    }
                                
                                
                            }
                        }
                    }
                    .mapStyle(viewModel.mode.getMode())
                    
                    
                    
                    .onTapGesture {perform in
                        
                        
                        if let coordinate = proxy.convert(perform, from: .local) {
                            
                            viewModel.addLocation(at: coordinate)
                        }
                        
                    }
                    .sheet(item: $viewModel.selectedLocation) { location in
                        EditView(location: location) {
                            viewModel.update(location: $0)
                        }
                    onDelete: {
                        viewModel.delete(location: $0)
                    }
                        
                    }
                }
                Picker("Mode",selection: $viewModel.mode) {
                    Text("Hybrid")
                        .tag(ViewModel.Mode.Hybrid)
                    
                    Text("Imagery")
                        .tag(ViewModel.Mode.Imagery)
                    
                    Text("Standard")
                        .tag(ViewModel.Mode.Standard)
                  
                }
                .padding()
                .background(.gray)
                .foregroundStyle(.green)
                .clipShape(.capsule)
                
            }
            .onAppear {
                viewModel.authenticate()
            }
                
        }
            
        else {
            VStack(spacing:30) {
                Text("Authentication Failed")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.red)
                    .clipShape(.capsule)
                
                Button("Try Agian",action: viewModel.authenticate)
                
                
                    
            }
           
            
        }
    }
    
}

#Preview {
    ContentView()
}
