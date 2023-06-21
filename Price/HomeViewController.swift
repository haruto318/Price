//
//  HomeViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let categories = ["iPhone", "Laptop", "backpack"]
    var selectedCategory: String = ""
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        self.performSegue(withIdentifier: "toComparePrice", sender: nil)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComparePrice"{
            let ComparePriceViewController = segue.destination as! ComparePriceViewController
            ComparePriceViewController.selectedCategory = self.selectedCategory
        }
    }

}
