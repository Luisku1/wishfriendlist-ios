//
//  User.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 26/04/22.
//

import Foundation
import FirebaseAuth

//Estructura de usuario que me va a permitir darle persistencia momentanea a los datos de un usuario en la ejecución de la aplicación
struct User {

    var uid : String, name: String, lastName: String, birthDate : String, phoneNumber : String, email : String, profileImage : String, provider : String
    
    var isFollowed = false
    
    var stats : UserStats!
    
    var isCurrent: Bool
    {
        
        return Auth.auth().currentUser?.uid == uid
    }
    
    var hasProfileImage : Bool
    {
        return profileImage != ""
    }
    
    init(){
        
        uid = ""
        name = ""
        lastName = ""
        birthDate = ""
        phoneNumber = ""
        email = ""
        profileImage = ""
        provider = ""
        self.stats = UserStats(followers: 0, following: 0)
    }
    
    //Inicializador por variable pasada por parámetro
    init(_ uid : String, _ name : String, _ lastName : String, _ birthDate : String, _ phoneNumber : String, _ email : String, _ profileImage : String, provider : String){
        
        self.uid = uid
        self.name = name
        self.lastName = lastName
        self.birthDate = birthDate
        self.phoneNumber = phoneNumber
        self.email = email
        self.profileImage = profileImage
        self.provider = provider
        self.stats = UserStats(followers: 0, following: 0)
    }
    
    //Inizializador que permite contraer un arreglo de diccionario de tipo [String: Any] para poder manejar con mayor facilidad la inicialización de un usuario cuando se recupera de la base de datos
    init(dictionary: [String: Any])
    {
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.birthDate = dictionary["birthDate"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.provider = dictionary["provider"] as? String ?? ""
    } 
}


struct UserStats
{
    let followers : Int
    let following : Int
    //let posts : Int
}
