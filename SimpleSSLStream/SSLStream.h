//
//  SSLStream.h
//
//  Created by sban@netspectrum.com on 7/9/12.
//  Copyright (c) 2012 Netspectrum Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSLStream;

@protocol SSLStreamDelegate <NSObject>

- (void)SSLStream:(SSLStream*)sslStream didReceiveString:(NSString*)string;
- (void)SSLStream:(SSLStream*)sslStream didReceiveData:(NSData*)data;

@end

@interface SSLStream : NSObject <NSStreamDelegate>{
    NSInputStream  *inputStream;
    NSOutputStream *outputStream;
}
@property (assign)id<SSLStreamDelegate>delegate;

- (id)initWithHost:(NSString*)host port:(int)port;
- (void)sendString:(NSString*)str;
- (void)sendData:(NSData*)data;
- (void)closeSSLStream;
@end
