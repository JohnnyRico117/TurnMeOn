#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@import UIKit;
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //[GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  //return [super application:application didFinishLaunchingWithOptions:launchOptions];

  [FIRApp configure];
  return YES;
}

@end
