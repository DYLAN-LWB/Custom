//
//  WBNetwork.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/23.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

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
