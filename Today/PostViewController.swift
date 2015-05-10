//
//  PostViewController.swift
//  Today
//
//  Created by Guest-Admin on 5/10/15.
//  Copyright (c) 2015 Viacom. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

class PostViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cameraView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoding of location failed with error " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                self.locationManager.stopUpdatingLocation()
                let city = placemarks[0].locality
                let country = placemarks[0].country
                self.cityLabel?.text = city
                self.getWeather(city, country: country)
            } else {
                println("Problem with the data")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func getWeather(city: String?, country: String?) {
        let url = "http://api.openweathermap.org/data/2.5/weather?q="+city!
        
        DataManager.loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            if let urlData = data {
                let json = JSON(data: urlData)
                let weather = json["weather"][0]["main"].string!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.weatherLabel?.text=weather;
                })
                
                ImageLoader.sharedLoader.imageForUrl("http://openweathermap.org/img/w/"+json["weather"][0]["icon"].string!+".png", completionHandler:{(image: UIImage?, url: String) in
                    self.weatherIcon?.image = image

                })
                
            }
        })
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        }
        else{
            NSLog("No Camera.")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        // Handle a still image capture
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage == nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            
            cameraView.image = imageToSave
            cameraView.reloadInputViews()
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil)
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
