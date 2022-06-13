//
//  CategoriesController.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 09/06/22.
//

import UIKit

class CategoriesController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredCategories = categories
    
    var category = ""
    
    var inSearchMode : Bool
    {
        return !searchBar.searchTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        searchBar.delegate = self
    }
}


extension CategoriesController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredCategories.count : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! CategoryCell
        
        let category = inSearchMode ? filteredCategories[indexPath.row] : categories[indexPath.row]
        
        cell.lblCategory.text = category.category
        cell.imgCategory.image = UIImage(named: category.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.category = categories[indexPath.row].id
        print("Debug Categories:- ´\(category)")
        performSegue(withIdentifier: "categoryToProducts", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categoryToProducts"
        {
            let vc = segue.destination as! ListOfWishObjects
            vc.category = self.category
        }
    }
    
    
}

extension CategoriesController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCategories = categories.filter({$0.category.lowercased().contains(searchText.lowercased())})
        
        self.categoriesTableView.reloadData()
    }
}
