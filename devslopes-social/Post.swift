//
//  Post.swift
//  devslopes-social
//
//  Created by Rebecca on 11/6/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}


class Profile {
    private var _username: String!
    private var _imageUrl: String!
    private var _profileKey: String!
    private var _profileRef: DatabaseReference!
    
    var username: String {
        return _username
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var profileKey: String {
        return _profileKey
    }
    
    init(username: String, imageUrl: String) {
        self._username = username
        self._imageUrl = imageUrl
    }
    
    init(profileKey: String, profileData: Dictionary<String, AnyObject>) {
        self._profileKey = profileKey
        
        if let username = profileData["username"] as? String {
            self._username = username
        }
        
        if let imageUrl = profileData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        _profileRef = DataService.ds.REF_PROFILE.child(_profileKey)
    }
}
