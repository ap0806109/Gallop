/*
 https://github.com/waynezxcv/Gallop

 Copyright (c) 2016 waynezxcv <liuweiself@126.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "SDImageCache+Gallop.h"
#import "LWCornerRadiusHelper.h"
#import <objc/runtime.h>

@implementation SDImageCache (Gallop)

+ (void)load {
    [super load];

    Method originMethod = class_getInstanceMethod([self class],
                                                  NSSelectorFromString(@"storeImage:recalculateFromImage:imageData:forKey:toDisk:"));

    Method newMethod = class_getInstanceMethod([self class],
                                               NSSelectorFromString(@"lw_storeImage:recalculateFromImage:imageData:forKey:toDisk:"));

    if (!class_addMethod([self class],
                         @selector(lw_storeImage:recalculateFromImage:imageData:forKey:toDisk:),
                         method_getImplementation(newMethod),
                         method_getTypeEncoding(newMethod))) {

        method_exchangeImplementations(newMethod, originMethod);
    }
}

- (void)lw_storeImage:(UIImage *)image
 recalculateFromImage:(BOOL)recalculate
            imageData:(NSData *)imageData
               forKey:(NSString *)key
               toDisk:(BOOL)toDisk {
    image = [LWCornerRadiusHelper lw_cornerRadiusImageWithImage:image withKey:key];
    if (key && [key hasPrefix:[NSString stringWithFormat:@"%@",LWCornerRadiusPrefixKey]]) {
        imageData = UIImagePNGRepresentation(image);
    }
    [self lw_storeImage:image recalculateFromImage:recalculate imageData:imageData forKey:key toDisk:toDisk];
}

@end
