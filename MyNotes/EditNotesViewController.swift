//
//  EditNotesViewController.swift
//  MyNotes
//
//  Created by AJAY BAJWA on 2019-03-23.
//  Copyright © 2019 lambton. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EditNotesViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    
    var locationManager:CLLocationManager!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBAction func btnSeeLocation(_ sender: UIButton) {
        
        /*if let url = URL(string: "https://www.google.com/maps/@\(mapLat),\(mapLong)z") {
            UIApplication.shared.open(url, options: [:])
        }*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "noteLocationSegue") {
            
            print("calling PREPARE function for Location")
            
            
            let locationVC = segue.destination as! NoteLocation
            
            //let i = (self.tableView.indexPathForSelectedRow?.row)!
            let mapLat:Double = note.lat
            let mapLong:Double = note.long
            locationVC.latitude = mapLat
            locationVC.longitude = mapLong
            
            
        }
        
        
    }
    
    @IBAction func alertView(_ sender: UIButton) {
        
        
        let pickerController = UIImagePickerController()
        
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add an Image", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImagePNGRepresentation(image) as NSData?
            //AppDelegate.saveContext()
            //self.noteImageView.image = image
            //let data = imageData
            self.noteImageView.image = UIImage(data: imageData! as Data)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    
    //++++++++ eh wala image lai
    // Image Picker

    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        
        
    }
    
    
    // ithe tak image
    
    var latitudeString:String = ""
    var longitudeString:String = ""
    // MARK: -- variables
    var note:Note!
    var notebook : Notebook?
    var userIsEditing = true;
    
    // MARK: -- database
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        if (userIsEditing == true) {
            print("Editing an existing note")
            txtTitle.text = note.title!
            textView.text = note.text!
            self.noteImageView.image = UIImage(data: note.image! as Data)
            lblLat.text = String(note.lat)
            lblLong.text = String(note.long)
            btnLocation.isHidden = false
        }
        else {
            print("Going to add a new note to: \(notebook!.name!)")
            textView.text = ""
            btnLocation.isHidden = true
        }
        //determineMyCurrentLocation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //determineMyCurrentLocation()
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        //latitudeString = "\(userLocation.coordinate.latitude)"
        //longitudeString = "\(userLocation.coordinate.longitude)"
        //let lat = userLocation.coordinate.latitude
        //let long = userLocation.coordinate.longitude
        note.lat = userLocation.coordinate.latitude
        note.long = userLocation.coordinate.longitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        // save text
        
        determineMyCurrentLocation()
        if (textView.text!.isEmpty) {
            print("Please enter some text")
            return
        }
        
        
        if (userIsEditing == true) {
            note.text = textView.text!
        }
        else {
            
            // create a new note in the notebook
            self.note = Note(context:context)
            note.setValue(Date(), forKey:"dateAdded")
            if (txtTitle.text!.isEmpty) {
                note.title = "No Title"
            }
            else{
                note.title = txtTitle.text!
            }
            note.text = textView.text!
            let imageData = UIImagePNGRepresentation(noteImageView.image!) as NSData?
            note.image = imageData
            //note.image = imagePickerController(<#T##picker: UIImagePickerController##UIImagePickerController#>, didFinishPickingMediaWithInfo: <#T##[String : Any]#>)
            note.notebook = self.notebook
        }
        
        do {
            try context.save()
            print("Note Saved!")
            
            
            // show an alert box
            let alertBox = UIAlertController(title: "Saved!", message: "Save Successful.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
        catch {
            print("Error saving note in Edit Note screen")
            
            // show an alert box with an error message
            let alertBox = UIAlertController(title: "Error", message: "Error while saving.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
        
        if (userIsEditing == false) {
            self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    

}

