//
//  SSLStream.m
//
//  Created by sban@netspectrum.com on 7/9/12.
//  Copyright (c) 2012 Netspectrum Inc. All rights reserved.
//

#import "SSLStream.h"

@implementation SSLStream
@synthesize delegate;

- (id)initWithHost:(NSString*)host port:(int)port{
    if (self = [super init]) {
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
        
        inputStream = (__bridge NSInputStream *)readStream;
        outputStream = (__bridge NSOutputStream *)writeStream;
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
        [outputStream open];
        
        NSDictionary *settings = [[NSDictionary alloc] 
                                  initWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
                                  [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
                                  [NSNull null],kCFStreamSSLPeerName,
                                  kCFStreamSocketSecurityLevelNegotiatedSSL, 
                                  kCFStreamSSLLevel,
                                  nil ];
        
        CFReadStreamSetProperty((__bridge CFReadStreamRef)inputStream, 
                                (CFStringRef)@"kCFStreamPropertySSLSettings", (__bridge CFTypeRef)settings);
        CFWriteStreamSetProperty((__bridge CFWriteStreamRef)outputStream, 
                                 (CFStringRef)@"kCFStreamPropertySSLSettings", (__bridge CFTypeRef)settings);
    }
    return self;
}

- (void)sendString:(NSString*)str{
    if (str && [str length] && outputStream) {
        NSString *endStr = [str stringByAppendingString:@"\n"];
        NSData *data = [NSData dataWithData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
    }
}

- (void)sendData:(NSData*)data{
    if (data && [data length] && outputStream) {
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
    }
}

- (void)closeSSLStream{
    if (inputStream) {
        [inputStream close];
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream setDelegate:nil];
        inputStream = nil;
    }
    if (outputStream) {
        [outputStream close];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream setDelegate:nil];
        outputStream = nil;        
    }
}

#pragma mark 
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)eventCode{
    
    switch (eventCode) {
        case NSStreamEventNone:
            NSLog(@"NSStreamEventNone");
            break;
            
        case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted - Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
        {
            if (theStream == inputStream) {
				uint8_t buffer[1024];
				int len;
				NSMutableData *data = [NSMutableData dataWithCapacity:0]; 
                
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        [data appendBytes:buffer length:len];
                    }
				}
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(SSLStream:didReceiveString:)]) {
                    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self.delegate SSLStream:self didReceiveString:output];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(SSLStream:didReceiveData:)]) {
                    [self.delegate SSLStream:self didReceiveData:data];
                }
			} else if (theStream == outputStream) {
                NSLog(@"OutputStream has status NSStreamEventHasBytesAvailable");                
            }
        }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"NSStreamEventErrorOccurred");
            break;
            
        case NSStreamEventEndEncountered:
        {
            NSLog(@"NSStreamEventEndEncountered");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;			
        }
            break;
            
        default:
            NSLog(@"unknown event");
            break;
    }
}
@end
