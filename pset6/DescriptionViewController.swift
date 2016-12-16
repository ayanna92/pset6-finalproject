//
//  DescriptionViewController.swift
//  pset6
//
//  Created by Ayanna Colden on 10/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class DescriptionViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var vineyardImage: UIImageView!
    @IBOutlet weak var vineyardLabel: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
 
    
    var ref:FIRDatabaseReference?
    let user = FIRAuth.auth()?.currentUser?.uid
    
    var wineName = String()
    var wineLabel = String()
    var wineRatings = Int()
    var wineVineyard = String()
    var wineVineyardName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        // Show variables of description page.
        nameLabel.text = wineName
        ratingLabel.text = "Rating is: \(String(wineRatings)) out of 100)"
        vineyardLabel.text = "Vineyard: \(wineVineyardName)"
        
        loadImageFromUrl(url: wineLabel, view: labelImage)
        
        loadImageFromUrl(url: wineVineyard, view: vineyardImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFavorites(_ sender: Any) {
        let alertController = UIAlertController(title: "Save wine", message: " Do you want to add this wine to your favorites?", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save",style: .default) { action in
            self.addFavoriteButton.isHidden = true
            
            // Save wine name to firebase database.
            if self.wineName != ""  {
                self.ref?.child("Users").child("Favorites").child(self.user!).child(self.wineName).child("Name").setValue(self.nameLabel.text)
                
                // Go to favorites table view.
                self.performSegue(withIdentifier: "descriptionToFavorites", sender: nil)
                
            } else {
                print ("error")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Log users out of Firebase.
    @IBAction func logOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let Error as NSError {
            print ("Error signing out: %@", Error)
        }
        self.performSegue(withIdentifier: "descriptionToLogin", sender: nil)
    }
    
   
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string.
        let url = NSURL(string: url)!
        
        // Download task:
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread.
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    
                })
            }
        }
        
        // Run task.
        task.resume()
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "descriptionToFavorites" {
            let favorites = segue.destination as! FavoritesTableViewController
            favorites.wineName = wineName
        }
    }
}
