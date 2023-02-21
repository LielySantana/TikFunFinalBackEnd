//
//  userVM.swift
//  TikKid
//
//  Created by Christina Santana on 20/2/23.
//

import Foundation
import UIKit

struct globalVM{
    
    
    func callAPI(urlRequest:URLRequest)async throws ->(Data?, URLResponse?){
        print("requested$$$$$$$$$$$$$$$$$$")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard response is HTTPURLResponse else {
            return (nil,nil)
        }
        return (data,response)
    }
    
    func getUserList(query: String) async -> [UserModel]?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/\(query)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")
        let session = URLSession.shared
        do{
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            do{
                var userList: [UserModel] = []
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                var userInfo = jsonData.value(forKey: "user") as? NSDictionary
                var profilePic = userInfo!.value(forKey: "avatar_168x168") as? NSDictionary
                var picUrl: [String] = profilePic!.value(forKey: "url_list") as! [String]
                
                var userId = userInfo!.value(forKey: "uid") as? String
                var nickname = userInfo!.value(forKey: "unique_id") as? String
                
                var userModel: UserModel = UserModel(profilePicUrl: picUrl[0], nickname: nickname!, userId: userId!)
                
                userList.append(userModel)
                return userList
                print(userModel)
                print("======================USER VM===================================")
                
            }catch{
                return nil
            }
        } catch{
            print(error)
            return nil
        }
    }
    
    
    func getUser(query: String) async -> UserModel?{
        
        let headers = [
            "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
            "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/\(query)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")
        let session = URLSession.shared
        do{
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            do{
                
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                var userInfo = jsonData.value(forKey: "user") as? NSDictionary
                var profilePic = userInfo!.value(forKey: "avatar_168x168") as? NSDictionary
                var picUrl: [String] = profilePic!.value(forKey: "url_list") as! [String]
                
                var userId = userInfo!.value(forKey: "uid") as? String
                var nickname = userInfo!.value(forKey: "unique_id") as? String
                
                var userModel: UserModel = UserModel(profilePicUrl: picUrl[0], nickname: nickname!, userId: userId!)
                
                
                return userModel
                print(userModel)
                print("======================USER VM===================================")
                
            }catch{
                return nil
            }
        } catch{
            print(error)
            return nil
        }
    }
    
    
    func getUserId(query: String) async ->String?{
        
        let headers = [
            "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
            "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")
        let session = URLSession.shared
        do{
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            do{
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                var userId = jsonData.value(forKey: "uid") as? String
                
                
                print(userId)
                print("======================USER ID VM===================================")
                return userId
            }catch{
                return nil
            }
        }
        catch{
            print(error)
            return nil
        }
        
    }
    
    
    func getPosts(query: String, comp: @escaping([VideoModel]?)->()){
        
        let headers = [
            "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
            "X-RapidAPI-Host": "scraptik.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://scraptik.p.rapidapi.com/user-posts?user_id=\(query)&count=6")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            if (error != nil) {
                comp(nil)
                return
            } else {
            
            do{
                var videoDown: VideoModel!
                var videoList: [VideoModel] = []
                
                
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                var aweme_list = jsonData.value(forKey: "aweme_list") as? [NSDictionary]
                
                for aweme in aweme_list!{
                    var videoUrl = aweme.value(forKey: "share_url") as? String
                    var videoID = aweme.value(forKey: "aweme_id") as? String
                    var author = aweme.value(forKey: "author") as? NSDictionary
                    
                    var authorId = author?.value(forKey: "uid") as? String
                    var authorPic = author!.value(forKey: "avatar_168x168") as? NSDictionary
                    var authorProfilePic = authorPic!.value(forKey: "url_list") as? [String]
                    var uniqueId = author?.value(forKey: "unique_id") as? String
                    
                    
                    var videoInfo = aweme.value(forKey: "video") as? NSDictionary
                    var cover = videoInfo!.value(forKey: "ai_dynamic_cover") as? NSDictionary
                    var coverUrl = cover?.value(forKey: "url_list") as? [String]
                    
                    
                    videoDown = VideoModel(authorId: authorId, authorName: uniqueId, authorPicUrl: authorProfilePic![0], videoId: videoID, coverUrl: coverUrl![0], videoUrl: videoUrl)
                    videoList.append(videoDown)
                }
                
                print(videoList)
                comp(videoList)
            }catch{
                comp(nil)
                
            }
        }
        })
        
        dataTask.resume()
    
        
        
    }
    
        
    }
    
    
//    func getPost(query: String) async->VideoModel?{
//
//        let headers = [
//            "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
//            "X-RapidAPI-Host": "scraptik.p.rapidapi.com"
//        ]
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://scraptik.p.rapidapi.com/user-posts?user_id=\(query)&count=6")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 20.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        let session = URLSession.shared
//        do{
//            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
//            if(data==nil){
//                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
//                return nil
//            }
//
//            do{
//
//                var videoDown: VideoModel!
//                var videoList: [VideoModel] = []
//
//
//                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
//                var aweme_list = jsonData.value(forKey: "aweme_list") as? [NSDictionary]
//
//                for aweme in aweme_list!{
//                    var videoUrl = aweme.value(forKey: "share_url") as? String
//                    var videoID = aweme.value(forKey: "aweme_id") as? String
//                    var author = aweme.value(forKey: "author") as? NSDictionary
//
//                    var authorId = author?.value(forKey: "uid") as? String
//                    var authorPic = author!.value(forKey: "avatar_168x168") as? NSDictionary
//                    var authorProfilePic = authorPic!.value(forKey: "url_list") as? [String]
//                    var uniqueId = author?.value(forKey: "unique_id") as? String
//
//
//                    var videoInfo = aweme.value(forKey: "video") as? NSDictionary
//                    var cover = videoInfo!.value(forKey: "ai_dynamic_cover") as? NSDictionary
//                    var coverUrl = cover?.value(forKey: "url_list") as? [String]
//
//
//                    videoDown = VideoModel(authorId: authorId, authorName: uniqueId, authorPicUrl: authorProfilePic![0], videoId: videoID, coverUrl: coverUrl![0], videoUrl: videoUrl)
//
//                }
//                videoList.append(videoDown)
//
//
//                print(videoDown)
//
//
//                return videoDown
//            }catch{
//                return nil
//
//            }
//        }
//        catch{
//            print(error)
//            return nil
//        }
//
//    }
    


