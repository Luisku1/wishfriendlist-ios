//
//  Event.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 27/04/22.
//

import Foundation

//Estructura de usuario que me va a permitir darle persistencia momentanea a los datos de un evento en la ejecución de la aplicación
struct Event
{
    let nameEvent : String
    let textEvent : String
    let imageEvent : String
    let timestamp : String
    var likes : Int
    let ownerUid : String
    let dateEvent : String
    let eventId : String
    let ownerImageUrl : String
    let ownerUserName : String
    let ownerUserLastName : String
    
    var hasImage: Bool
    {
        return imageEvent != ""
    }
    
    init(eventId : String, dictionary: [String: Any])
    {
        self.ownerUid = dictionary["ownerUid"] as! String
        self.nameEvent = dictionary["nameEvent"] as! String
        self.textEvent = dictionary["textEvent"] as! String
        self.imageEvent = dictionary["imageEvent"] as! String
        self.dateEvent = dictionary["dateEvent"] as! String
        self.timestamp = dictionary["timestamp"] as? String ?? ""
        self.likes = dictionary["likes"] as! Int
        self.eventId = eventId
        self.ownerImageUrl = dictionary["ownerImageUrl"] as! String
        self.ownerUserName = dictionary["ownerUserName"] as! String
        self.ownerUserLastName = dictionary["ownerUserLastName"] as! String
    }
}
