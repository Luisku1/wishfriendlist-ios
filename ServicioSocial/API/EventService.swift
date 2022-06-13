//
//  EventService.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 26/05/22.
//

import UIKit
import Firebase

//Estructura que define funciones para el manejo primario de los datos de un evento en conjunto a la base de datos de Firebase.
struct EventService
{
    static func uploadEvent(nameEvent : String, dateEvent : String, textEvent : String, image : UIImage?, imageSelected: Bool, user: User, completion: @escaping(FirestoreCompletion))
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if imageSelected
        {
            ImageUploader.uploadEventImage(image: image!) { imageUrl in
                
                let data : [String: Any] = [
                    "nameEvent" : nameEvent,
                    "textEvent" : textEvent,
                    "dateEvent" : dateEvent,
                    "timestamp" : Timestamp(date: Date()),
                    "likes" : 0,
                    "imageEvent" : imageUrl,
                    "ownerUid" : uid,
                    "ownerImageUrl": user.profileImage,
                    "ownerUserName": user.name,
                    "ownerUserLastName": user.lastName
                ]
                
                COLLECTION_EVENTS.addDocument(data: data, completion: completion)
            }
        
        } else {
            
            let data : [String: Any] = [
                "nameEvent" : nameEvent,
                "textEvent" : textEvent,
                "dateEvent" : dateEvent,
                "timestamp" : Timestamp(date: Date()),
                "likes" : 0,
                "imageEvent" : "",
                "ownerUid" : uid,
                "ownerImageUrl": user.profileImage,
                "ownerUserName": user.name,
                "ownerUserLastName": user.lastName
            ]
            
            COLLECTION_EVENTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func getEvents(completion: @escaping([Event]) -> Void)
    {
        COLLECTION_EVENTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot?.documents else { return }
            
            let events = snapshot.map({Event(eventId: $0.documentID, dictionary: $0.data())})
            completion(events)
        }
    }
}
