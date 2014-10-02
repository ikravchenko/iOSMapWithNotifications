import Foundation
import MapKit

class CoordinateFinder : NSObject {
    var mapItems = Array<MKMapItem>()
    
    init(address : String!, inRegion: MKCoordinateRegion!) {
        super.init()
        forwardGeocodeAddresses(address, inRegion: inRegion)
    }
    
    func forwardGeocodeAddresses(address: String!, inRegion: MKCoordinateRegion!) {
        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        request.region = inRegion
        var search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            if error == nil {
                self.mapItems = response.mapItems as [MKMapItem]
                NSNotificationCenter.defaultCenter().postNotificationName("Address Found", object: self)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("Not Found", object: self)
            }
            
        }
    }
}
