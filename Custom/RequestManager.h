//
//  RequestManager.h
//  Basic
//
//  Created by 李伟宾 on 15/11/30.
//  Copyright © 2015年 李伟宾. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadProgress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface RequestManager : NSObject

+ (RequestManager *)sharedManger;

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
                  failure:(void(^)(NSError * error))failure;

/**
 *  上传单张图片
 *
 *  @param imageData 图片二进制流 SData *imageData = UIImageJPEGRepresentation(image, 0.7);
 *  @param url       上传图片接口地址
 *  @param params    封装的参数,id,key等
 *  @param success   success description
 *  @param failure   failure description
 */
- (void)uploadImageWithImageData:(NSData *)imageData
                             url:(NSString *)url
                          params:(NSDictionary *)params
                         success:(void(^)(id response))success
                         failure:(void(^)(NSError * error))failure;

@end
