//
//  WBNetwork.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/23.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit


let UserID    = "3"
let UserKey   = "b648cd8969ca4528f0956b1052926e08"
let BasicUrl  = "http://shop.51titi.net"   // 线上测试环境

func RequestName(name:String) -> String {
   return (BasicUrl + "/" + name + "/uid/" + UserID + "/key/" + UserKey)
}

let port1  = RequestName(name: "showbooks/booklist")

//工具类
enum RequestType {
    case GET
    case POST
}

class WBNetwork: AFHTTPSessionManager {

    static let shareInstance : WBNetwork = {
        let tool = WBNetwork()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tool
    }()
    
    func request(requestType: RequestType, url : String, params: [String : Any], success: @escaping([String : Any]?) ->(),failure: @escaping( _ error : Error?) -> ()){
        //成功
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            success(responseObj as? [String : Any])
        }
        
        //失败
        let failureBlock = {(task : URLSessionDataTask?,error:Error) in
            failure(error)
        }
        
        //GET
        if requestType == .GET {
            get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        //POST
        if requestType == .POST {
            post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
}
