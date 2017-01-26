import Foundation
import Firebase
import JSQMessagesViewController

class ModelController {
    
    static let sharedController = ModelController()
    
    
    var authData: FIRUser?
    
    let onlineRef = FIRDatabase.database().reference(withPath: "online")
    var currentUsers: [String] = []
    
    var users: [User] = []
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    var user: User!
    var otherUser: User!
    var filteredUsers: [User] = []
    var userIndex: Int?
    
    var channels: [Channel] = []
    var channelRef = FIRDatabase.database().reference(withPath: "channels")
    var channel: Channel!
    var channelToDelete: Channel?
    var cameFromUserVC: Bool? = false
    
    var reportRef = FIRDatabase.database().reference(withPath: "reports")
    
    private var channelRefHandle: FIRDatabaseHandle?
    
    
    
    var newMessageRefHandle: FIRDatabaseHandle?
    var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://friendfindr-b5b12.appspot.com")
    var messages = [JSQMessage]()
    
    
    
    func signIn(email: String, password: String) {
        
        
        FIRAuth.auth()!.signIn(withEmail: email,
                               password: password)
        
    }
    
    
    func createUser(email: String, password: String, username: String, bio: String, completion: @escaping (() -> Void) = { _ in }) {
        FIRAuth.auth()!.createUser(withEmail: email,
                                   password: password) { authData, error in
                                    if error == nil {
                                        //3
                                        self.authData = authData
                                    
                                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                            guard let auth = FIRAuth.auth(), let user = user else { return }
                                            
//                                            let imageName = NSUUID().uuidString
//                                            
//                                            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
//                                            guard let uploadData = UIImagePNGRepresentation(image) else { return }
                                            
//                                            storageRef.put(uploadData, metadata: nil, completion: {
//                                                (metadata, error) in
//                                                
//                                                if error != nil {
//                                                    print(error as Any)
//                                                    return
//                                                }
                                            
//                                                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                                                let userData = ["username": username, "bio": bio, "uid": authData?.uid, "email": authData?.email, "location": "", "age": "", "politics": "", "favorites": "", "interests": ""]
                                                
                                                self.registerUserToDatabase(username: username, bio: bio, userData: userData)
                                            
                                                self.currentUsersChanged(auth: auth, user: user)
                                            
                                            })
                                            
                                        
                                            completion()
                                        
                                        
                                    }
        }
    }
    
    
    
    func registerUserToDatabase(username: String, bio: String, userData: [String: Any]) {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(authData!.uid).setValue(userData)
        
    }

    
    
    func currentUsersChanged(auth: FIRAuth, user: FIRUser) {
        
        self.usersRef.child(user.uid).observe( .value, with: { snapshot in
            if snapshot.value != nil {
                guard let user = User(authData: user, snapshot: snapshot) else { return }
                self.user = user
                let currentUserRef = self.onlineRef.child(self.user.uid)
                currentUserRef.setValue(self.user.email)
                currentUserRef.onDisconnectRemoveValue()
            }
        })
    }
    
    
    
    
    
    
    func usersList(completion: @escaping (() -> Void) = { _ in }) {
        usersRef.queryOrderedByPriority().observe(.value, with: { snapshot in
            var usersList: [User] = []
            
            
            guard let allUsersDict = snapshot.value as? [String:  [String: Any]] else { return }
            
            for individualDict in allUsersDict.values {
                guard let uid = individualDict["uid"] as? String,
                    let email = individualDict["email"] as? String,
                    let username = individualDict["username"] as? String,
                    let bio = individualDict["bio"] as? String else { return }
                
                guard let location = individualDict["location"] as? String else { return }
                guard let age = individualDict["age"] as? String else { return }
                guard let politics = individualDict["politics"] as? String else { return }
                guard let favorites = individualDict["favorites"] as? String else { return }
                guard let interests = individualDict["interests"] as? String else { return }
//                guard let profileImageUrl = individualDict["profileImageUrl"] as? String else { return }
                
                print("\(uid) \(email) \(username) \(bio)")
                if uid != self.user.uid {
                    let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                    usersList.append(user)
                }
            }
            self.users = usersList.shuffled()
            completion()
        })
    }
    
    
    func loadChannels(completion: @escaping (() -> Void) = { _ in }) {
        
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let user = channelData["user"] as? String, let otherUser = channelData["otherUser"] as? String, let userId = channelData["userId"] as? String, let otherUserId = channelData["otherUserId"] as? String, let lastMessage = channelData["lastMessage"] as? String, let userLastRead = channelData["userLastRead"] as? String, let otherUserLastRead = channelData["otherUserLastRead"] as? String {
                print("\(id) \(user) \(otherUser) \(userId) \(otherUserId) \(lastMessage)")
                if userId.contains(self.user.uid) || otherUserId.contains(self.user.uid) {
                    self.channels.append(Channel(id: id, user: user, otherUser: otherUser, userId: userId, otherUserId: otherUserId, lastMessage: lastMessage, userLastRead: userLastRead, otherUserLastRead: otherUserLastRead, snapshot: snapshot))
                }
            }
            completion()
        })
        
    }
    
    func clearChannels() {
        
        self.channels = []
        
    }
    
    func clearMessages() {
        
        self.messages = []
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func checkChannels(completion: @escaping (() -> Void) = { _ in }) {
        
        
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let user = channelData["user"] as? String, let otherUser = channelData["otherUser"] as? String, let userId = channelData["userId"] as? String, let otherUserId = channelData["otherUserId"] as? String, let lastMessage = channelData["lastMessage"] as? String, let userLastRead = channelData["userLastRead"] as? String, let otherUserLastRead = channelData["otherUserLastRead"] as? String {
                print("\(id) \(user) \(otherUser) \(userId) \(otherUserId)")
                if userId.contains(self.user.uid) && otherUserId.contains(self.otherUser.uid) {
                    self.channel = Channel(id: id, user: user, otherUser: otherUser, userId: userId, otherUserId: otherUserId, lastMessage: lastMessage, userLastRead: userLastRead, otherUserLastRead: otherUserLastRead, snapshot: snapshot)
                    completion()
                }
            }
        })
        
        
    }
    
    
    
    
    func createChannel(user: String, otherUser: String, userId: String, otherUserId: String, lastMessage: String, userLastRead: String, otherUserLastRead: String) {
        let newChannelRef = self.channelRef.childByAutoId() // 2
        let channelItem = [ // 3
            "user": user,
            "otherUser": otherUser,
            "userId": userId,
            "otherUserId": otherUserId,
            "lastMessage": lastMessage,
            "userLastRead": userLastRead,
            "otherUserLastRead": otherUserLastRead
            ] as [String : Any]
        newChannelRef.setValue(channelItem) // 4
    }
    
    
    func createReport(reporter: String, user: String, text: String) {
        let newReportRef = self.reportRef.childByAutoId()
        let reportItem = [
            "reporter": reporter,
            "user": user,
            "text": text
        ]
        newReportRef.setValue(reportItem)
    }
    
    
    
    
    
    func search(searchText: String, criteria: String, completion: @escaping (() -> Void) = { _ in }) {
        usersRef.queryOrderedByPriority().observe(.value, with: { snapshot in
            var searchList: [User] = []
            
            
            guard let allUsersDict = snapshot.value as? [String:  [String: Any]] else { return }
            
            for individualDict in allUsersDict.values {
                guard let uid = individualDict["uid"] as? String,
                    let email = individualDict["email"] as? String,
                    let username = individualDict["username"] as? String,
                    let bio = individualDict["bio"] as? String else { return }
                
                guard let location = individualDict["location"] as? String else { return }
                guard let age = individualDict["age"] as? String else { return }
                guard let politics = individualDict["politics"] as? String else { return }
                guard let favorites = individualDict["favorites"] as? String else { return }
                guard let interests = individualDict["interests"] as? String else { return }
//                guard let profileImageUrl = individualDict["profileImageUrl"] as? String else { return }
                
                print("\(uid) \(email) \(username) \(bio)")
                
                switch(criteria) {
                case "Username":
                    if username.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                case "Bio":
                    if bio.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                case "Location":
                    if location.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                case "Age":
                    guard let intSearchText = Int(searchText) else { return }
                    if age != "" {
                        guard let intAge = Int(age) else { return }
                        if intSearchText-2...intSearchText+2 ~= intAge {
                            if uid != self.user.uid {
                                let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                                searchList.append(user)
                            }
                        }
                    }
                    
                case "Politics":
                    if politics.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                case "Favorites":
                    if favorites.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                case "Interests":
                    if interests.lowercased().contains(searchText.lowercased()) {
                        if uid != self.user.uid {
                            let user = User(uid: uid, email: email, username: username, bio: bio, location: location, age: age, politics: politics, favorites: favorites, interests: interests)
                            searchList.append(user)
                        }
                    }
                default:
                    break
                }
            }
            
            self.users = searchList
            completion()
        })
    }
    
    
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
