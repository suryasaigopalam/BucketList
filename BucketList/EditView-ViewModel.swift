//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by surya sai on 05/06/24.
//

import Foundation

extension EditView {
    
    @Observable
    class ViewModel {
        
        var location:Location
        
     var name:String
        
   var description:String
        
        var onSave:(Location)->Void
        
      var loadingState = LoadingSate.loading
        
         var pages:[Page] = []
        
        var onDelete:(Location)->Void
        
        init(location:Location,onSave: @escaping (Location)->Void, onDelete: @escaping  (Location)->Void) {
            self.location = location
            name =   location.name
            description =  location.descriptor
            self.onSave = onSave
            self.onDelete = onDelete
        }
        
        func fetchNearbyPlaces() async  {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {return}
            do {
                let data = try await URLSession.shared.data(from: url).0
                let items = try JSONDecoder().decode(Result.self, from: data)
                 pages = [Page] (items.query.pages.values).sorted(by: <)
               
            
                loadingState = .loaded
                
            }catch {
               loadingState = .failed
            }
                    
        }
        
    }
    
}
