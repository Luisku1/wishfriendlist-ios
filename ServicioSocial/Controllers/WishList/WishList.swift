//
//  WishList.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 20/04/22.
//

import UIKit
import FirebaseAuth

class WishList: UITableViewController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    var segueInfo = "current"
    var user : User?
    private var wishList = [WishObject]()
    var object = WishObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if segueInfo == "not current"
        {
            addBarButton.isEnabled = false
        }
        
        loadWishList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWishList()
    }

    func loadWishList()
    {
        if user != nil
        {
            navigationItem.title = "\(user!.name)'s Wish List"
            
            WishListService.getWishListUser(uid: self.user!.uid) { wishList in
                
                self.wishList = wishList
                
                self.tableView.reloadData()
            }
    
        } else {

                
            UserService.getUser { user in
                
                self.user = user
    
                self.navigationItem.title = "\(user.name)'s Wish List"
                
                WishListService.getWishListUser(uid: user.uid) { wishList in
                    
                    self.wishList = wishList
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wishList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let wishObject = tableView.dequeueReusableCell(withIdentifier: "wishObject", for: indexPath) as! WishObjectCell
        
        let object = wishList[indexPath.row]
        
        wishObject.lblObjectName.text = object.name
        wishObject.lblObjectDisponibility.text = object.stock > 0 ? "On Stock" : "Out of Stock"
        wishObject.objectImage.image = UIImage(named: object.image)
        wishObject.lblPersonalDescription.text = object.personalDescription
        
        
        return wishObject
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.object = wishList[indexPath.row]
        
        performSegue(withIdentifier: "wishListToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "wishListToDetail"
        {
            let detailController = segue.destination as! WishObjectView
            detailController.object = self.object
        }
    }
    
    //Función que permitirá borrar un elemento de la tabla con un swipe del lado derecho.
    override func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        if uid == user?.uid
        {
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil){
                (_, _, completionHandler) in
                
                let idObject = self.wishList[indexPath.row].id
                
                guard let uid = self.user?.uid else { return }
                
                WishListService.deleteWishObject(uid: uid, id: idObject, vc: self)
                
                self.wishList.remove(at: indexPath.row)
                
                self.tableView.reloadData()
                completionHandler(true)
            }
            
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            
            return configuration
        }
        
        return nil
        
    }
    
    @IBAction func addNewWishObject(_ sender: Any) {

        performSegue(withIdentifier: "wishListToCategory", sender: nil)
    }
}
