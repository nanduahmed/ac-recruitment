//
//  ViewController.swift
//  Realtor
//
//  Created by Nandu Ahmed on 4/4/18.
//  Copyright © 2018 Baabul Ilm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var places = [Place]()

    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    var section1Items = ["Display All on Map"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let mapVC = segue.destination as? MapDetailViewController
            if (indexPath.section == 0 && self.places.count > 1) {
                mapVC?.displayMultiple = true
            }
            mapVC?.coordinates = self.places[indexPath.row].coordinates
        }
    }


}

extension ViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {// Default is 1 if not implemented
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if (self.places.count > 1) {
                return 1
            }
            return 0
        case 1:
            return self.places.count
        default:
            return self.places.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
            cell?.textLabel?.text = self.section1Items[indexPath.row]
            return cell!
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        cell?.textLabel?.text = self.places[indexPath.row].address
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMapSegue", sender: indexPath)
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {// called when keyboard search button pressed
        
        NetworkManager.shared.getData(values:searchBar.text!) { (success, data, models) in
            self.places.removeAll()
            if (success && (models != nil) && (models?.count)! > 0 && Models.shared.status == .Ok) {
                self.places = models!
                self.showError(value: nil)
                DispatchQueue.main.async {
                    self.tbView.reloadData()
                }

            }
            
            else {
                // Display Error 
                if (success == false) {
                    DispatchQueue.main.async(execute: { 
                        self.showError(value: "Google API Error")
                    })
                }
                
                if (Models.shared.status == .ZeroResults) {
                    DispatchQueue.main.async(execute: {
                        self.showError(value: "Zero Results")
                    })

                }
                
            }
            
        }
    }
    
    private func showError(value:String?) {
        if let value = value {
            self.tbView.alpha = 0.0
            self.errorLabel.isHidden = false
            self.errorLabel.text = value
        } else {
            self.tbView.alpha = 1.0
            self.errorLabel.isHidden = true
        }
    }
}
