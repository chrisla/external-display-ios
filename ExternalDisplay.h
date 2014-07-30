//
//  ExternalDisplay.h
//
//  Created by cla on 8/22/12.
//  Copyright (c) 2012 Chris La. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExternalDisplay : NSObject

@property (strong, nonatomic) UIScreen *externalScreen;
@property (strong, nonatomic) UIWindow *externalWindow;
@property (strong, nonatomic) MainViewController *extViewController;

- (void) unregisterScreenNotification;
- (void) screenDidConnect:(NSNotification *) aNotification;
- (void) screenDidDisconnect:(NSNotification *) aNotification;
- (void) screenModeDidChange:(NSNotification *) aNotification;
- (void) interfaceOrientationWillChange:(NSNotification *)aNotification;
- (void) processExtWindow;

@end
