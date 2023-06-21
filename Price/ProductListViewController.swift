//
//  ProductListViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

import Firebase

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet var storeNameLabel: UILabel!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.addObserver(self, forKeyPath: "price", options: [.new], context: nil)
        
        getProducts()

    }
    
    func getProducts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("store").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.data()!["name"] as? String
                print(name)
                self.storeNameLabel.text = name
            } else {
                print("Document does not exist")
            }
        }
        
     }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
//        cell.textLabel?.text = self.categories[indexPath.row]
//        return cell
//    }
        

}
