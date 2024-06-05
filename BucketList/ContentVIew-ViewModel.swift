//
//  ContentVIew-ViewModel.swift
//  BucketList
//
//  Created by surya sai on 03/06/24.
//

import Foundation
import MapKit
import LocalAuthentication
import _MapKit_SwiftUI


extension ContentView {
    @Observable
    class ViewModel {
        
        enum Mode {
            case Hybrid,Imagery,Standard
            
            func getMode()->MapStyle {
                switch self {
                case .Hybrid:.hybrid
                case .Imagery:.imagery
                case .Standard: .standard
                    
                }
                
            }
        }
        
        var locations:[Location]
        
        var selectedLocation:Location?
        
        let savedPath = URL.documentsDirectory.appendingPathComponent("SavedPlaces", conformingTo: .utf8PlainText)
        
        var isUnlocked:Bool = true
    
        var mode:Mode = .Standard
        
        init() {
            do {
                let data  = try Data(contentsOf: savedPath)
                locations = try JSONDecoder().decode([Location].self, from: data)
                
                
            }catch {
                locations = []
            }
            
        }
        
        func addLocation(at point:CLLocationCoordinate2D) {
            
            let newLocation = Location(id: UUID(), name: "new location", descriptor: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
            
        }
        
        func update(location:Location) {
            let index = locations.firstIndex(of: selectedLocation!)!
                locations.remove(at: index)
          locations.insert(location, at: index)
            save()
        }
        
        func delete(location:Location) {
            let index = locations.firstIndex(of: location)!
           locations.remove(at: index)
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
               try data.write(to: savedPath,options: [.atomic,.completeFileProtection])
                
            }catch {
                print("Unable to save data")
            }
            
        }
        
        func authenticate() {
            let context = LAContext()
            
            
            var error:NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error ) {
                let reason = "Please authenticate yourself"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                    
                    if $0 {self.isUnlocked = true}
                    else {
                        print($1!.localizedDescription)
                        self.isUnlocked = false
                    }
                    
                    
                }
                    
                
                
            }
            else {
                print("No Biometrics on this Device  ")
            }
            
        }
    }
    
    }



