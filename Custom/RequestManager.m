//
//  RequestManager.m
//  Basic
//
//  Created by 李伟宾 on 15/11/30.
//  Copyright © 2015年 李伟宾. All rights reserved.
//

#import "RequestManager.h"

@implementation FileModel

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename {
    
    FileModel *file = [[self alloc] init];
    file.name = name;
    file.fileData = data;
    return file;
}

@end

@implementation RequestManager

+ (AFHTTPSessionManager*)sharedHTTPSessionManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.operationQueue.maxConcurrentOperationCount = 5;  // 设置允许同时最大并发数量，过大容易出问题
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    return manager;
}

#pragma mark - POST/GET网络请求

+ (NSURLSessionTask *)requestWithURLString:(NSString *)URLString
                                parameters:(NSMutableDictionary *)parameters
                                      type:(HttpRequestType)type
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    NSURLSessionTask *session = nil;
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    parameters[@"uid"] = WBUserID;
    parameters[@"key"] = WBUserKey;

    switch (type) {
        case HttpRequestTypeGet: {
            session = [manager GET:URLString
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                               if (success)
                                   success(response);
                           }
                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               if (failure)
                                   failure(error);
                           }];
        }
            break;
            
        case HttpRequestTypePost: {
            session = [manager POST:URLString
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                if (success)
                                    success(response);
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                if (failure)
                                    failure(error);
            }];
        }
            break;
    }
    return session;
}

#pragma mark - 上传图片

+ (NSURLSessionTask *)uploadWithURLString:(NSString *)URLString
                               parameters:(NSMutableDictionary *)parameters
                                 progress:(RequestProgress)progress
                              uploadParam:(FileModel *)uploadParam
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    parameters[@"uid"] = WBUserID;
    parameters[@"key"] = WBUserKey;
    
    NSURLSessionTask *session = [manager POST:URLString
                                   parameters:parameters
                    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                        [formData appendPartWithFileData:uploadParam.fileData
                                                    name:uploadParam.name
                                                fileName:@"hehe"            // 图片名称, 随便给
                                                mimeType:@"image/jpg"];     // 图片类型 image/jpg
                    }
                                     progress:^(NSProgress * _Nonnull uploadProgress){
                                         if(progress)
                                             progress(uploadProgress);
                                     }
                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                          if (success)
                                              success(response);
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          if (failure)
                                              failure(error);
                                      }];
    
    return session;
}

#pragma mark - 下载文件

+ (NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString
                                       savePathURL:(NSURL *)fileURL
                                          progress:(RequestProgress )progress
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    
    NSURL *urlpath = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                         if(progress)
                                                                             progress(downloadProgress);
                                                                     }
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                      return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                  }
                                                            completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                if (error)
                                                                    failure(error);
                                                                else
                                                                    success(response);
                                                            }];
    
    [downloadtask resume];
    
    return downloadtask;
}

@end
