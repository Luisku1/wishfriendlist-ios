import Firebase
import FirebaseFirestore
import UIKit

typealias FirestoreCompletion = (Error?) -> Void

//Estructura que define funciones para el manejo primario de los datos de un usuario en conjunto a la base de datos de Firebase.
struct UserService{

    static func getUser (completion: @escaping(User) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument {
            
            (documentSnapshot, error) in
            
            guard let dictionary = documentSnapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            
            completion(user)
        }
    }
    
    static func getUsers(completion: @escaping([User]) -> Void) {
        
        COLLECTION_USERS.getDocuments {
            (documentSnapshot, error) in
            
            guard let documentSnapshot = documentSnapshot else { return }
            
            let users = documentSnapshot.documents.map({
                User(dictionary: $0.data())
            })
            
            completion(users)
        }
    }
    
    static func getProfileImage(completion: @escaping(String) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            
            guard let profileUrl = snapshot?.data() else  { return }
            
            completion(profileUrl["profileImage"] as! String)
        }
    }
    
    static func deleteUser(vc : UIViewController)
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).delete { error in
            
            if let error = error
            {
                sendAlert(title: "Error", message: error.localizedDescription, vc)
            }
        }
    }
    
    static func updateUser(withCredential credentials: AuthCredentials, changePhoto : Bool, provider: ProviderType, _ viewController: UIViewController, completion: @escaping(Error?) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        if changePhoto
        {
            if let profileImage = credentials.profileImage
            {
                ImageUploader.uploadProfileImage(image: profileImage) { imageUrl in
                    
                    COLLECTION_USERS.document(uid).setData([
                        
                        "email" : credentials.email,
                        "name": credentials.name,
                        "lastName": credentials.lastName,
                        "birthDate": credentials.birthDate,
                        "phoneNumber": credentials.phoneNumber,
                        "profileImage": imageUrl,
                        "uid": uid,
                        "provider": provider.rawValue
                    
                    ])
                }
            }
            
        } else {
            
            UserService.getProfileImage { url in
                
                COLLECTION_USERS.document(uid).setData([
                    
                    "email" : credentials.email,
                    "name": credentials.name,
                    "lastName": credentials.lastName,
                    "birthDate": credentials.birthDate,
                    "phoneNumber": credentials.phoneNumber,
                    "profileImage": url,
                    "uid": uid,
                    "provider": provider.rawValue
                
                ])
            }
        }
        
        viewController.navigationController?.popViewController(animated: true)
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion))
    {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion))
    {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)
    {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func getUserStats(uid : String, completion: @escaping(UserStats) -> Void)
    {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            
            let followers = snapshot?.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                
                let following = snapshot?.count ?? 0
                
                completion(UserStats(followers: followers, following: following))
            }
        }
    }
}
