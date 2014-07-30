//
//  ExternalDisplay.m
//
//  Created by cla on 8/22/12.
//  Copyright (c) 2012 Chris La. All rights reserved.
//

#import "Ed.h"

@implementation ExternalDisplay

@synthesize externalScreen;
@synthesize externalWindow;
@synthesize extViewController;

- (id)init
{
    
    self = [super init];
    if (self == nil) {
        DBG_INIT(self);
        return self;
    }
    
    [self registerScreenNotification];
    [self processExtWindow];
    
    return self;
}
    
    
- (void) registerScreenNotification
{
    // Register for screen notifications
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [center addObserver:self selector:@selector(screenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
    
    // Register for interface orientation changes (so we don't need to query on every frame refresh)
    [center addObserver:self selector:@selector(interfaceOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}


- (void) unregisterScreenNotification
{
    // Unregister from screen notifications
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [center removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
    [center removeObserver:self name:UIScreenModeDidChangeNotification object:nil];
    
    // Device orientation
    [center removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}


- (void) screenDidConnect:(NSNotification *) aNotification
{
    DBG_ENTER();
    [[MainViewController get] setExternalDisplay];
    [self processExtWindow];
}


- (void) screenDidDisconnect:(NSNotification *) aNotification
{
    DBG_ENTER();
    
    [[MainViewController get] unsetExternalDisplay];
    
}


- (void) screenModeDidChange:(NSNotification *) aNotification
{
    DBG_ENTER();
}


- (void) interfaceOrientationWillChange:(NSNotification *)Notification
{
    DBG_LOG(@"rotating");
}


- (void) processExtWindow
{
    
    DBG_ENTER();
    
    // If we already init, return
    if (extViewController != nil) {
        return;
    }
    
    if (extViewController != nil) {
        return;
    }
    
    if ([[UIScreen screens] count] > 1) {
        
        externalScreen = [[UIScreen screens] objectAtIndex:1];
        
        externalWindow = [[UIWindow alloc] initWithFrame:[externalScreen bounds]];
        
        externalWindow.screen = externalScreen;
        
        NSArray *screenModes = externalScreen.availableModes;
		DBG_LOG("@Available modes: %@", screenModes);
        
        // find the largest supported resolution
        int index = 0;
        CGFloat maxres = 0;
        int maxindex = 0;
        
        for (UIScreenMode *mode in screenModes) {
            if (maxres < mode.size.height * mode.size.width) {
                maxres = mode.size.height * mode.size.width;
                maxindex = index;
            }
            index++;
        }
   
        UIScreenMode *desiredMode = [screenModes objectAtIndex:maxindex];

        DBG_LOG(@"Setting mode: %@", desiredMode);
        externalScreen.currentMode = desiredMode;

        CGRect rect = CGRectZero;
        rect.size = desiredMode.size;
        
        externalWindow.frame = rect;
        
        externalWindow.clipsToBounds = YES;
        
        extViewController = [[MainViewController alloc] initWithFrame:externalWindow.frame];
        externalWindow.rootViewController = extViewController;
        
        externalWindow.hidden = NO;
    }
    
}



@end
