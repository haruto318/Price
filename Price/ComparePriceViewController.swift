//
//  ComparePriceViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

class ComparePriceViewController: UIViewController {
    var selectedCategory: String = ""
    
    @IBOutlet var categoryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = selectedCategory
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
