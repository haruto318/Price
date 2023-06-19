//
//  CategoryViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/14.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    let realm = try! Realm()
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        categories = readCategories()
    }
    
//    func readCategorieds() -> [Category]{
//        return Array(realm.objects(Category.self))
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
