//
//  SearchUsers.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 26/04/22.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import FirebaseAuth

class SearchUsers: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersFound: UITableView!
    
    //Declaración de variables
    var user: User = User()
    private var users = [User]()
    private var filteredUsers = [User]()
    
    //inSearchMode es una variable de tipo Bool que al momento de ser usada evalúa si la barra de búsqueda tiene algo dentro, para que de esta forma podamos saber que se está tratando de filtar a los usuarios
    private var inSearchMode: Bool {
        
        return !searchBar.searchTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegado de TableView y de SearchBar
        searchBar.delegate = self
        usersFound.delegate = self
        usersFound.dataSource = self
        
        getUsers()
    }
    
    //getUsers recupera los usuarios existentes en la base de datos y los guarda en la ejecución del programa dentro de la variable users
    func getUsers()
    {
        UserService.getUsers { users in
            
            self.users = users
            self.usersFound.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as! UserCell
        
        //Se evalúa si hay que filtrar o no a los usuarios
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        cell.userFullName.text = "\(user.name) \(user.lastName)"
        
        //Condición que evalúa si un usuario tiene o no una imagen de perfil, ya que en caso de no tener hay que ocupar la imagen default ("defaultProfileImage")
        if user.profileImage != ""
        {
            cell.userPhoto.sd_setImage(with: URL(string: user.profileImage))
        
        } else {
            
            cell.userPhoto.image = UIImage(named: "defaultProfileImage")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        performSegue(withIdentifier: "searchToProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchToProfile"
        {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let profileController = segue.destination as! Profile
            profileController.user = self.user
            
            if self.user.uid != uid
            {
                profileController.segueInfo = "not current"
            }
        }
    }
    
    //Función que pertenece al protocolo del searchbar. Lo que hace es filtrar a los usuarios dependiendo del texto ingresado en el textfield de búsqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUsers = users.filter({ "\($0.name) \($0.name)".lowercased().contains(searchText.lowercased()) })
        
        self.usersFound.reloadData()
        
    }
}
