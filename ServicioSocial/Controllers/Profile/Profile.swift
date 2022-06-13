//
//  Profile.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 06/04/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData
import GoogleSignIn
import WebKit
import SwiftUI
import SDWebImage

class Profile: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblBirthDate: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
    
    var user : User = User()
    var segueInfo = "current"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadProfileView()
    {
        //Las siguientes 4 líneas de código nos ayudan a darle una forma circular a la imagen de perfil de usuario, además de colocarle un borde de color "systemIndigo"
        profileImage.layer.cornerRadius = profileImage.bounds.size.height / 2.0
        profileImage.layer.borderColor = UIColor.systemIndigo.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.clipsToBounds = true
        
        
        if segueInfo != "current"
        {
            checkIfUserIsFollowed()
            settingsButtonItem.isEnabled = false
        
        } else {
        
            showUserInformation()
        }
    }
    
    func checkIfUserIsFollowed()
    {
        UserService.checkIfUserIsFollowed(uid: self.user.uid)
        {
            isFollowed in
            
            self.user.isFollowed = isFollowed
            self.showUserInformation()
        }
    }
    
    func getUserStatsAndSetInformation()
    {
        UserService.getUserStats(uid: self.user.uid) { stats in
            
            self.user.stats = stats
            self.lblFollowers.text = String(self.user.stats.followers)
            self.lblFollowing.text = String(self.user.stats.following)
            
            self.lblFullName.text = "\(self.user.name) \(self.user.lastName)"
            self.lblEmail.text = self.user.email
            self.lblBirthDate.text = self.user.birthDate
            self.lblPhoneNumber.text = self.user.phoneNumber
            
            self.navigationItem.title = "\(self.user.name) \(self.user.lastName)"
            
            if self.user.hasProfileImage
            {
                self.profileImage.sd_setImage(with: URL(string: self.user.profileImage))
            }
        }
    }
    
    //showUserInformation es una función que muestra la información del usuario en cuestión (Puede ser un usuario obtenido de la búsqueda de usuarios, o el mismo usuario loggeado
    func showUserInformation(){
        
        //Se distingue entre el usuario loggeado y uno diferente
        if segueInfo == "current"
        {
            
            self.followUnfollowButton.isHidden = true
            //Se obtiene la información del usuario loggeado
            UserService.getUser { [self] user in
                self.user = user
                getUserStatsAndSetInformation()
            }
            
        } else {
            
            //Se desplega la información del usuario enviado por medio de un segue
            
            getUserStatsAndSetInformation()
            
            if user.isFollowed
            {
                followUnfollowButton.setTitle("Unfollow", for: .normal)
                followUnfollowButton.setTitleColor(UIColor.systemRed, for: .normal)
                
            } else {
                
                followUnfollowButton.setTitle("Follow", for: .normal)
                followUnfollowButton.setTitleColor(UIColor.systemPurple, for: .normal)
            }
        }
    }
    
    //wishListButton activa el segue que muestra la pantalla de wishList del usuario en cuestión
    @IBAction func wishListButton(_ sender: Any) {
        
        performSegue(withIdentifier: "profileToWishList", sender: nil)
        
    }
    
    //followUnfollowAction permite seguir a un usuario. Pero este botón estará oculto cuando se trata del usuario loggeado
    @IBAction func followUnfollowAction(_ sender: Any) {
        
        if user.isFollowed
        {
            UserService.unfollow(uid: user.uid) { error in
                
                self.user.isFollowed = false
                self.showUserInformation()
            }
            
        } else {
            
            UserService.follow(uid: user.uid) { error in
                
                self.user.isFollowed = true
                self.showUserInformation()
            }
        }
    }
    
    //prepare nos ayuda a preparar el segue y enviar los datos necesarios hacia la escena destino
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profileToWishList"
        {
            let wishListController = segue.destination as! WishList
            
            if !self.user.isCurrent
            {
                wishListController.segueInfo = "not current"
                wishListController.user = self.user
            }
        }
    }
}
