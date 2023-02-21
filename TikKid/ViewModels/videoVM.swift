//
//  videoVM.swift
//  TikKid
//
//  Created by Christina Santana on 20/2/23.
//

import Foundation

struct VideoVM{
    func getPost(query: String, comp: @escaping([VideoModel]?)->()){
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
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
                var videoList: [VideoModel] = []
                
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                var aweme_list = jsonData.value(forKey: "aweme_list") as? [NSDictionary]
                var videoUrl = aweme_list![0].value(forKey: "share_url") as? String
                var videoID = aweme_list![0].value(forKey: "aweme_id") as? String
                var author = aweme_list![0].value(forKey: "author") as? NSDictionary
                
                var authorId = author?.value(forKey: "uid") as? String
                var authorPic = author!.value(forKey: "avatar_168x168") as? NSDictionary
                var authorProfilePic = authorPic!.value(forKey: "url_list") as? [String]
                var uniqueId = author?.value(forKey: "unique_id") as? String
                
                
                var videoInfo = aweme_list![0].value(forKey: "video") as? NSDictionary
                var cover = videoInfo!.value(forKey: "ai_dynamic_cover") as? NSDictionary
                var coverUrl = cover?.value(forKey: "url_list") as? [String]
                
                
                
            
                
                
                var videoDown: VideoModel = VideoModel(authorId: authorId, authorName: uniqueId, authorPicUrl: authorProfilePic![0], videoId: videoID, coverUrl: coverUrl![0], videoUrl: videoUrl)
                videoList.append(videoDown)
                print(videoDown)
                
                comp(videoList)
            }catch{
                comp(nil)
            }
        }
})

dataTask.resume()



}
}
