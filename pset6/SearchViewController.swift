//
//  SearchViewController.swift
//  pset6
//
//  Created by Ayanna Colden on 09/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchName: UITextField!
    
    var ref: FIRDatabaseReference?
    
    var id = Int()
    var wineName = [String]()
    var wineLabel = [String]()
    var wineRatings = [Int]()
    var wineVineyard = [String]()
    var wineVineyardName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func searchButton(_ sender: Any) {
        
        requestHTTPName(Title: searchName.text!)
        
        // Empty textfield after search.
        searchName.text = ""
        
        // Empty table view after search.
        wineName.removeAll()
        wineLabel.removeAll()
        wineVineyard.removeAll()
        wineVineyardName.removeAll()
        wineRatings.removeAll()
        tableView.reloadData()
    }
    
    func requestHTTPName(Title: String) {
        
        let urlString = Title.replacingOccurrences(of: " ", with: "+")
        
        let url = URL(string: "https://services.wine.com/api/beta2/service.svc/JSON/catalog?apikey=c2243334463cd408c6c276806d22b7f6&size=5&search=" + urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            guard error == nil else {
                print("error!")
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                let products = json.value(forKey: "Products") as! NSDictionary
                let list = products.value(forKey: "List") as! Array<NSDictionary>
                
                // Wine name.
                for items in list {
                    Wine.name = items.object(forKey: "Name") as! String
                    Wine.id = items.object(forKey: "Id") as! Int
                    self.wineName.append(Wine.name)
                }
                
                
                // Initialize list.
                let n = self.wineName.count
                let listing = list[0..<n]
                //print(labels)
                
                for list in listing {
                    
                    // Url label images.
                    let label = list.object(forKey: "Labels") as! Array<NSDictionary>
                    for url in label {
                        Wine.label = url.object(forKey: "Url") as! String
                        self.wineLabel.append(Wine.label)
                    }
                    
                    // Ratings for wine
                    let rating = list.object(forKey: "Ratings") as! NSDictionary
                    Wine.rating = rating.value(forKey: "HighestScore") as! Int
                    self.wineRatings.append(Wine.rating)
                    
                    
                    // Vineyard image url and name.
                    let vineyard = list.object(forKey: "Vineyard") as! NSDictionary
                    Wine.vineyard = vineyard.value(forKey: "ImageUrl") as! String
                    Wine.vineyardName = vineyard.value(forKey: "Name") as! String
                    self.wineVineyard.append(Wine.vineyard)
                    self.wineVineyardName.append(Wine.vineyardName)
                }
                
            } catch {
                print(error)
            }
            
            self.tableView.reloadData()
            
        }).resume()
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return wineName.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        loadImageFromUrl(url: self.wineLabel[indexPath.row], view: cell.labelImage)
        
        cell.nameLabel.text = wineName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         performSegue(withIdentifier: "searchToDescription", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDescription" {
            let description = segue.destination as! DescriptionViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            description.wineName = wineName[indexPath.row]
            description.wineLabel = wineLabel[indexPath.row]
            description.wineRatings = wineRatings[indexPath.row]
            description.wineVineyard = wineVineyard[indexPath.row]
            description.wineVineyardName = wineVineyardName[indexPath.row]
        }
    }
    


}
