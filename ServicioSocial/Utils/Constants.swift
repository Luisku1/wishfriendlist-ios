//
//  Constants.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 27/04/22.
//

import Foundation
import FirebaseFirestore


let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_EVENTS = Firestore.firestore().collection("events")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_WISHLIST = Firestore.firestore().collection("wishlists")
