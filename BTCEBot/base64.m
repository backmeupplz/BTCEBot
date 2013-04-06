#import <Foundation/Foundation.h>
#import "NSData+Base64.h"
#import <Security/cssm.h>

#include <openssl/bio.h>
#include <openssl/evp.h>

NSString *base64Encode(NSData *data)
{
    // Construct an OpenSSL context
    BIO *context = BIO_new(BIO_s_mem());

    // Tell the context to encode base64
    BIO *command = BIO_new(BIO_f_base64());
    context = BIO_push(command, context);

    // Encode all the data
    BIO_write(context, [data bytes], [data length]);
    BIO_flush(context);

    // Get the data out of the context
    char *outputBuffer;
    long outputLength = BIO_get_mem_data(context, &outputBuffer);
    NSString *encodedString =
		[[[NSString alloc]
			initWithBytes:outputBuffer
			length:outputLength
			encoding:NSUTF8StringEncoding]
		autorelease];

    BIO_free_all(context);

    return encodedString;
}

NSString *base64Decode(NSString *decode)
{
	decode = [decode stringByAppendingString:@"\n"];
	NSData *data = [decode dataUsingEncoding:NSASCIIStringEncoding];
	
    // Construct an OpenSSL context
    BIO *command = BIO_new(BIO_f_base64());
    BIO *context = BIO_new_mem_buf((void *)[data bytes], [data length]);
		
    // Tell the context to encode base64
    context = BIO_push(command, context);

    // Encode all the data
	NSMutableData *outputData = [NSMutableData data];
	
	#define bufsize 256
	int len;
	char inbuf[bufsize];
	while ((len = BIO_read(context, inbuf, bufsize)) > 0)
	{
		[outputData appendBytes:inbuf length:len];
	}

    // Get the data out of the context
    NSString *encodedString =
		[[[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding]
			autorelease];

    BIO_free_all(context);

    return encodedString;
}

NSString *md5Encode(NSData *data)
{
    // Construct an OpenSSL context
    BIO *context = BIO_new(BIO_s_mem());

    // Tell the context to encode base64
    BIO *command = BIO_new(BIO_f_md());
    BIO_set_md(command, EVP_md5());
    context = BIO_push(command, context);

    // Encode all the data
    BIO_write(context, [data bytes], [data length]);
    BIO_flush(context);

    // Get the data out of the context
    unsigned char outputBuffer[EVP_MAX_MD_SIZE];
    long outputLength = BIO_gets(context, (char *)outputBuffer, EVP_MAX_MD_SIZE);
	
	NSMutableString *encodedString = [NSMutableString string];
	for (int i = 0; i < outputLength; i++)
	{
		[encodedString appendFormat:@"%02X", outputBuffer[i]];
	}

    BIO_free_all(context);

    return encodedString;
}

int main (int argc,  const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSString *initialString = @"This is a smaller string. Ansdfgsdfgsdfgsdfgsdfgsdfgsdfgd some other stuff.\n";
	NSData *data = [initialString dataUsingEncoding:NSASCIIStringEncoding];
	NSString *base64String = [data base64EncodedString];
	NSData *decoded = [NSData dataFromBase64String:base64String];
	NSString *decodedString =
		[[[NSString alloc]
			initWithBytes:[decoded bytes]
			length:[decoded length]
			encoding:NSUTF8StringEncoding]
		autorelease];

    // insert code here...
	NSCAssert([initialString isEqualToString:decodedString], @"whoops");
    NSLog(@"\n%@\n\n%@", base64String, decodedString);
	
//	NSLog(@"Second encode: %@", base64Encode(data));
	NSLog(@"md5 encode: %@", md5Encode([@"some text\n" dataUsingEncoding:NSUTF8StringEncoding]));
	
    [pool drain];
    return 0;
}
