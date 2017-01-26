/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  var username: String
  var bio: String
    var location: String
    var age: String
    var politics: String
    var favorites: String
    var interests: String
//    var profileImageUrl: String
  let ref: FIRDatabaseReference?
  
  
  init?(authData: FIRUser, snapshot: FIRDataSnapshot) {
    
    guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return nil }
    uid = authData.uid
    email = authData.email!
    
    ref = snapshot.ref
    username = snapshotValue["username"] as! String
    bio = snapshotValue["bio"] as! String
    location = snapshotValue["location"] as? String ?? ""
    age = snapshotValue["age"] as? String ?? ""
    politics = snapshotValue["politics"] as? String ?? ""
    favorites = snapshotValue["favorites"] as? String ?? ""
    interests = snapshotValue["interests"] as? String ?? ""
//    profileImageUrl = snapshotValue["profileImageUrl"] as? String ?? ""
  }
  
    init(uid: String, email: String, username: String, bio: String, location: String?, age: String?, politics: String?, favorites: String?, interests: String?) {
    self.uid = uid
    self.email = email
    self.username = username
    self.bio = bio
    self.location = location ?? ""
    self.age = age ?? ""
    self.politics = politics ?? ""
    self.favorites = favorites ?? ""
    self.interests = interests ?? ""
//    self.profileImageUrl = profileImageUrl ?? ""
    self.ref = nil
  }
  
    init(authData: FIRUser, username: String, bio: String, location: String?, age: String?, politics: String?, favorites: String?, interests: String?) {
    uid = authData.uid
    email = authData.email!
    self.username = username
    self.bio = bio
    self.location = location ?? ""
    self.age = age ?? ""
    self.politics = politics ?? ""
    self.favorites = favorites ?? ""
    self.interests = interests ?? ""
//    self.profileImageUrl = profileImageUrl ?? ""
    self.ref = nil
  }
  
  func toAnyObject() -> Any {
    return [
      "username": username,
      "bio": bio,
      "email": email,
      "uid": uid,
      "location": location,
      "age": age,
      "politics": politics,
      "favorites": favorites,
      "interests": interests,
//      "profileImageUrl": profileImageUrl
    ]
  }
  
}
