//
// AppGiraffe Phonegap-Plugin Copyright (c) 2013 AppGiraffe, LLC
//
// AGApplicationPreferences
//
// Author:  Dave Ferrell
// Version: 3.0.1
//
#import "AGApplicationPreferences.h"


@implementation AGApplicationPreferences

- (void)get:(CDVInvokedUrlCommand*)command
{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;
    
    if ([arguments count] >= 1)
    {
        NSString* key = [arguments objectAtIndex:0];
        
        @try {
            NSString *returnVar = [[NSUserDefaults standardUserDefaults] stringForKey:key];
            if(returnVar == nil)
            {
                returnVar = [self getSettingFromBundle:key]; //Parsing Root.plist
                
                if (returnVar == nil)
                    @throw [NSException exceptionWithName:nil reason:@"Key not found" userInfo:nil];;
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                             messageAsString:returnVar];
        }
        @catch (NSException *exception) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT
                                             messageAsString:[exception reason]];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"incorrect number of arguments for get"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)set:(CDVInvokedUrlCommand*)command
{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;
    
    if ([arguments count] >= 2)
    {
        NSString* key   = [arguments objectAtIndex:0];
        NSString* value = [arguments objectAtIndex:1];
        
        @try {
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        @catch (NSException *exception) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT
                                             messageAsString:[exception reason]];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"incorrect number of arguments for set"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)remove:(CDVInvokedUrlCommand*)command
{
    [self notSupported:command];
}

- (void)clear:(CDVInvokedUrlCommand*)command
{
    [self notSupported:command];
}

- (void)load:(CDVInvokedUrlCommand*)command
{
    [self notSupported:command];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    [self notSupported:command];
}

- (void)notSupported:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:@"method not supported in iOS"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
  Parsing the Root.plist for the key, because there is a bug/feature in Settings.bundle
  So if the user haven't entered the Settings for the app, the default values aren't accessible through NSUserDefaults.
*/


- (NSString*)getSettingFromBundle:(NSString*)settingsName
{
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
	NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
	
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	NSDictionary *prefItem;
	for (prefItem in prefSpecifierArray)
	{
		if ([[prefItem objectForKey:@"Key"] isEqualToString:settingsName]) 
			return [prefItem objectForKey:@"DefaultValue"];		
	}
	return nil;
	
}
@end
