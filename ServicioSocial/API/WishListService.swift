//
//  WishListService.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import Foundation
import Firebase
import UIKit

struct WishListService
{
    static func addObjectToWishList(wishObject : WishObject, completion: @escaping(FirestoreCompletion))
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data : [String: Any] =
        [
            "id" : wishObject.id,
            "objectName" : wishObject.name,
            "objectPrice" : wishObject.price,
            "disponibility" : wishObject.stock,
            "image" : wishObject.image,
            "personalD" : wishObject.personalDescription
        ]
        
        COLLECTION_WISHLIST.document(uid).collection("wishlist").document(wishObject.id).getDocument{
            snapshot, error in
            
            if let snapshot = snapshot, !snapshot.exists
            {
                COLLECTION_WISHLIST.document(uid).collection("wishlist").document(wishObject.id).setData(data, completion: completion)
            }
        }
    }
    
    static func getWishListUser(uid : String, completion: @escaping([WishObject]) -> Void)
    {
        COLLECTION_WISHLIST.document(uid).collection("wishlist").getDocuments{
            
            snapshot, error in
            
            guard let snapshot = snapshot?.documents else { return }
            
            let wishList = snapshot.map({WishObject(dictionary: $0.data())})
            completion(wishList)
        }
    }
    
    static func deleteWishObject(uid : String, id : String, vc : UIViewController)
    {
        COLLECTION_WISHLIST.document(uid).collection("wishlist").document(id).delete {
            
            error in
            
            if let error = error
            {
                sendAlert(title: "Error", message: error.localizedDescription, vc)
            }
        }
    }
}
