import Cordova
import Cordova
import Cordova
import Foundation
import WindowsAzureMessaging


/*
 * Notes: The @objc shows that this class & function should be exposed to Cordova.
 */
@objc(PushNotification) class PushNotification : CDVPlugin, MSNotificationHubDelegate {
    @objc(run:) // Declare your function name.
    func run(command: CDVInvokedUrlCommand) { // write the function code.
        let options = command.arguments[0] as! [String:Any]
        let connectionString = options["connectionString"] as! String
        let hubName = options["notificationHubPath"] as! String
        
        
        MSNotificationHub.setDelegate(self)
        MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
        let deviceToken = MSNotificationHub.getPushChannel()
        let installationId =  MSNotificationHub.getInstallationId()
        
        
        if(installationId.isEmpty || deviceToken.isEmpty) {
            let pushSelf:PushNotification = self
            NSLog("Waiting for push device registration")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let deviceToken = MSNotificationHub.getPushChannel()
                let installationId =  MSNotificationHub.getInstallationId()
                var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error");
                if(installationId.isEmpty || deviceToken.isEmpty) {
                    NSLog("Error registering push device")
                    pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                }
                else {
                    let result: [String:String] = ["registrationId":deviceToken,"azureRegId":"$InstallationId:{"+installationId+"}"]
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
                }
                pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                
            }
        }
        else {
            let result: [String:String] = ["registrationId":deviceToken,"azureRegId":"$InstallationId:{"+installationId+"}"]
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    
    
    @objc(addTags:) // Declare your function name.
    func addTags(command: CDVInvokedUrlCommand) { // write the function code.
        let options = command.arguments[0] as! [String:Any]
        let connectionString = options["connectionString"] as! String
        let hubName = options["notificationHubPath"] as! String
        
        let tags = options["tags"] as! [String]
        
        MSNotificationHub.setDelegate(self)
        MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
        let deviceToken = MSNotificationHub.getPushChannel()
        let installationId =  MSNotificationHub.getInstallationId()
        
        if(installationId.isEmpty || deviceToken.isEmpty) {
            let pushSelf:PushNotification = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let pluginResult1 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error - register device for push first")
                pushSelf.commandDelegate!.send(pluginResult1, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Add Tags to MSNotificationHub");
            if (MSNotificationHub.addTags(tags)) {
                let result: [String:String] = ["Tags added": tags.joined(separator:"-")]
                let pluginResult2 = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
                self.commandDelegate!.send(pluginResult2, callbackId: command.callbackId);
            } else {
                let pluginResult3 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error at addTags - Tags could not be added");
                NSLog("Error at addTags - Tags could not be added")
                self.commandDelegate!.send(pluginResult3, callbackId: command.callbackId);
            }
        }
    }
    
    @objc(removeTag:) // Declare your function name.
    func removeTag(command: CDVInvokedUrlCommand) { // write the function code.
        let options = command.arguments[0] as! [String:Any]
        let connectionString = options["connectionString"] as! String
        let hubName = options["notificationHubPath"] as! String
        let tag = options["tag"] as! String
        
        MSNotificationHub.setDelegate(self)
        MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
        let deviceToken = MSNotificationHub.getPushChannel()
        let installationId =  MSNotificationHub.getInstallationId()
        
        if(installationId.isEmpty || deviceToken.isEmpty) {
            let pushSelf:PushNotification = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let pluginResult1 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error - register device for push first")
                pushSelf.commandDelegate!.send(pluginResult1, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Remove Tag to MSNotificationHub");
            if (MSNotificationHub.removeTag(tag)) {
                let result: [String:String] = ["Tag got removed":tag]
                let pluginResult2 = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
                self.commandDelegate!.send(pluginResult2, callbackId: command.callbackId);
            } else {
                let pluginResult3 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error at removeTag - Tag could not be removed");
                NSLog("Error at removeTag - Tag could not be removed")
                self.commandDelegate!.send(pluginResult3, callbackId: command.callbackId);
            }
        }
        
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        
        // Send the function result back to Cordova.
        
    }

    @objc(removeTags:) // Declare your function name.
    func removeTags(command: CDVInvokedUrlCommand) { // write the function code.
        let options = command.arguments[0] as! [String:Any]
        let connectionString = options["connectionString"] as! String
        let hubName = options["notificationHubPath"] as! String
        
        let tags = options["tags"] as! [String]
        
        MSNotificationHub.setDelegate(self)
        MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
        let deviceToken = MSNotificationHub.getPushChannel()
        let installationId =  MSNotificationHub.getInstallationId()
        
        if(installationId.isEmpty || deviceToken.isEmpty) {
            let pushSelf:PushNotification = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let pluginResult1 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error - register device for push first")
                pushSelf.commandDelegate!.send(pluginResult1, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Remove Tags from MSNotificationHub");
            if (MSNotificationHub.removeTags(tags)) {
                let result: [String:String] = ["Tags removed": tags.joined(separator:"-")]
                let pluginResult2 = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
                self.commandDelegate!.send(pluginResult2, callbackId: command.callbackId);
            } else {
                let pluginResult3 = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error at removeTags - Tags could not be removed");
                NSLog("Error at removeTags - Tags could not be removed")
                self.commandDelegate!.send(pluginResult3, callbackId: command.callbackId);
            }
        }
    }
    
    
    @objc(getTags:) // Declare your function name.
    func getTags(command: CDVInvokedUrlCommand) { // write the function code.
        let options = command.arguments[0] as! [String:Any]
        let connectionString = options["connectionString"] as! String
        let hubName = options["notificationHubPath"] as! String
        
        MSNotificationHub.setDelegate(self)
        MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
        let deviceToken = MSNotificationHub.getPushChannel()
        let installationId =  MSNotificationHub.getInstallationId()
        
        if(installationId.isEmpty || deviceToken.isEmpty) {
            let pushSelf:PushNotification = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error - register device for push first")
                pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Get Tags to MSNotificationHub");
            let result: [String: [String]] = ["tags":MSNotificationHub.getTags()];
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
        
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        
        // Send the function result back to Cordova.
        
    }
}

