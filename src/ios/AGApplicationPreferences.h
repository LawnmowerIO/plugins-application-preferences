//
// AppGiraffe Phonegap-Plugin Copyright (c) 2013 AppGiraffe, LLC
//
// AGApplicationPreferences
//
// Author:  Dave Ferrell
// Version: 3.0.1
//
#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>

@interface AGApplicationPreferences : CDVPlugin { }

- (void)get:(CDVInvokedUrlCommand*)command;
- (void)set:(CDVInvokedUrlCommand*)command;

// not supported
- (void)remove:(CDVInvokedUrlCommand*)command;
- (void)clear:(CDVInvokedUrlCommand*)command;
- (void)load:(CDVInvokedUrlCommand*)command;
- (void)show:(CDVInvokedUrlCommand*)command;

@end
