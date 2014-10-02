import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView : MKMapView!
    @IBOutlet var searchField : UITextField!
    var finder: CoordinateFinder!
    
    @IBAction func search (sender: UITextField!) {
        var region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(0.58, 0.58))
        self.mapView.removeAnnotations(self.mapView.annotations)
        finder = CoordinateFinder(address: sender.text, inRegion: region)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "Address Found", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "Not Found", object: nil)
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "mapTapped"))
        searchField.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
    }
    
    func receivedNotification(notification: NSNotification) {
        switch(notification.name) {
        case "Address Found":
            addAnnotations()
        case "Not Found":
            var alert = UIAlertView(title: "No Results Found", message: nil, delegate: self, cancelButtonTitle: "OK")
            alert.show()
        default:
            println("Unknown notificaton")
        }
    }
    
    func addAnnotations() {
        for item in finder.mapItems {
            var annotation = MKPointAnnotation()
            annotation.coordinate = item.placemark.coordinate
            annotation.title = item.name
            annotation.subtitle = item.placemark.title
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapTapped() {
        searchField.endEditing(true)
    }
}

