//
//  RequestManager.m
//  Basic
//
//  Created by 李伟宾 on 15/11/30.
//  Copyright © 2015年 李伟宾. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface RequestManager()

@property (nonatomic, strong) AFHTTPRequestOperation *manager;
@property (nonatomic) AFHTTPRequestOperationManager  *requestManager;
@end

@implementation RequestManager

+ (RequestManager *)sharedManger {
    static RequestManager *instance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
/**
 *  请求接口
 *
 *  @param methodType 分为post和get
 *  @param url        请求的url
 *  @param params     请求的参数
 *  @param success    返回成功
 *  @param failure    返回失败
 */
- (void)requestWithMethod:(NSString *)methodType
                      url:(NSString *)url
                   params:(NSDictionary *)params
                  success:(void(^)(id response))success
                  failure:(void(^)(NSError * error))failure {
    
    AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer = [AFHTTPRequestSerializer serializer];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([methodType isEqualToString:@"GET"]) {
        url = [NSString stringWithFormat:@"%@/from-ios", url];
    }
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:methodType
                                                              URLString:url
                                                             parameters:params
                                                                  error:nil];
    request.timeoutInterval = 30;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *set = [[NSMutableSet alloc] initWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"application/json"];
    [set addObject:@"text/json"];
    [set addObject:@"text/javascript"];
    [set addObject:@"text/html"];
    [set addObject:@"text/css"];
    [self.requestManager.operationQueue addOperation:operation];
    operation.responseSerializer.acceptableContentTypes = set;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@" %@   msg = %@  code = %@", url, responseObject[@"msg"], responseObject[@"code"]);

//        if ([WBString(responseObject[@"code"]) isEqualToString:@"99"]) {
//            //请先登录
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_ShowLogin object:self userInfo:nil];
//        }
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"url = %@    - msg = %@", url , error);

        failure(error);
    }];

    [operation start];
}

/**
 *  上传单张图片
 *
 *  @param imageData 图片二进制流 NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
 *  @param url       上传图片接口地址
 *  @param params    封装的参数,id,key等
 *  @param success   success description
 *  @param failure   failure description
 */
- (void)uploadImageWithImageData:(NSData *)imageData
                             url:(NSString *)url
                          params:(NSDictionary *)params
                         success:(void(^)(id response))success
                         failure:(void(^)(NSError * error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // name 服务器给的字段名称
        // fileName 图片名称, 随便给
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"file.jpg" mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperationManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPRequestOperationManager manager] ;
    }
    return _requestManager;
}

@end
