//
//  NewWishObject.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import UIKit

class ListOfWishObjects: UIViewController{
    
    @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var searchObjectsBar: UISearchBar!
    
    var filteredObjectList = wishObjects
    var object : WishObject = WishObject()
    var category : String?
    var objects : [WishObject] = [WishObject]()
    
    private var inSearchMode : Bool
    {
        return !searchObjectsBar.searchTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = wishObjects.filter({$0.category.contains(category!)})
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        searchObjectsBar.delegate = self
        wishListTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        objects = wishObjects.filter({$0.category.contains(category!)})
        wishListTableView.reloadData()
        
    }
}


extension ListOfWishObjects : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredObjectList.count : objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let wishObject = tableView.dequeueReusableCell(withIdentifier: "wishObjectFromList", for: indexPath) as! ListsObjectCell
        
        let wishObjectToDisplay = inSearchMode ? filteredObjectList[indexPath.row] : objects[indexPath.row]
        
        wishObject.lblObjectName.text = wishObjectToDisplay.name
        wishObject.lblObjectPrice.text = "$\(wishObjectToDisplay.price)"
        wishObject.lblObjectDisponibility.text = wishObjectToDisplay.stock > 0 ? "On Stock" : "Out of Stock"
        print("Debug:- \(wishObjectToDisplay.personalDescription)")
        wishObject.objectImage.image = UIImage(named: wishObjectToDisplay.image)
        
        return wishObject
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.object = inSearchMode ? filteredObjectList[indexPath.row] : objects[indexPath.row]
        performSegue(withIdentifier: "listOfProductsToDetail", sender: nil)
    }
    
    func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let addObjectToWishList = UIContextualAction(style: .destructive, title: nil){
            (_, _, completionHandler) in
            
            let wishObject = self.inSearchMode ? self.filteredObjectList[indexPath.row] : self.objects[indexPath.row]
            
            self.addObjectToWishList(wishObject)
            
            completionHandler(true)
        }
        
        addObjectToWishList.image = UIImage(systemName: "plus")
        addObjectToWishList.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [addObjectToWishList])
        
        return configuration
    }
    
    func addObjectToWishList(_ wishObject : WishObject)
    {
        WishListService.addObjectToWishList(wishObject: wishObject) { error in
            
            if error == nil
            {
                sendAlert(title: "Added!", message: "This object has been added to your wish list", self)
            
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "listOfProductsToDetail"
        {
            let detailController = segue.destination as! WishObjectView
            
            detailController.object = self.object
            
        }
    }
}

extension ListOfWishObjects : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredObjectList = objects.filter({ "\($0.name) \($0.name)".lowercased().contains(searchText.lowercased()) })
        
        self.wishListTableView.reloadData()
        
    }
}
