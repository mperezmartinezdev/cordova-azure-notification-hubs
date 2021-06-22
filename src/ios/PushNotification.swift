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
                let pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error registering push device")
                pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Add Tags to MSNotificationHub");
            MSNotificationHub.addTags(tags);
            
            let result: [String:String] = ["registrationId":deviceToken,"azureRegId":"$InstallationId:{"+installationId+"}"]
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
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
                let pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
                NSLog("Error registering push device")
                pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
        else {
            NSLog("Remove Tag to MSNotificationHub");
            MSNotificationHub.removeTag(tag);
            let result: [String:String] = ["registrationId":deviceToken,"azureRegId":"$InstallationId:{"+installationId+"}"]
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

