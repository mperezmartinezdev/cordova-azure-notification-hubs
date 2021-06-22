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
    NSLog("Tags", options["tags"])
    if (options["tags"] != nil) {
        let tagString = options["tags"] as? String
        let tags = Set<AnyHashable>(tagString?.components(separatedBy: ","))
    }

    MSNotificationHub.setDelegate(self)
    MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
    if (tags != " " && tags != nil) {
        NSLog("Add Tags to MSNotificationHub");
        MSNotificationHub.addTags(tags);
    } 
    let deviceToken = MSNotificationHub.getPushChannel()
    let installationId =  MSNotificationHub.getInstallationId()


    if(MSNotificationHub) {
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


    @objc(addTags:) // Declare your function name.
  func addTags(command: CDVInvokedUrlCommand) { // write the function code.
    let options = command.arguments[0] as! [String:Any]
    let connectionString = options["connectionString"] as! String
    let hubName = options["notificationHubPath"] as! String
    NSLog("Tags", options["tags"])
    if (options["tags"] != nil) {
        let tagString = options["tags"] as? String
        let tags = Set<AnyHashable>(tagString?.components(separatedBy: ","))
    }

    MSNotificationHub.setDelegate(self)
    MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
    let deviceToken = MSNotificationHub.getPushChannel()
    let installationId =  MSNotificationHub.getInstallationId()

    if(installationId.isEmpty || deviceToken.isEmpty) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
            NSLog("Error registering push device")
            pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    else {
        if (tags != " " && tags != nil) {
            NSLog("Add Tags to MSNotificationHub");
            MSNotificationHub.addTags(tags);
        } 
        let result: [String:String] = ["registrationId":deviceToken,"azureRegId":"$InstallationId:{"+installationId+"}"]
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

        @objc(removeTag:) // Declare your function name.
  func removeTag(command: CDVInvokedUrlCommand) { // write the function code.
    let options = command.arguments[0] as! [String:Any]
    let connectionString = options["connectionString"] as! String
    let hubName = options["notificationHubPath"] as! String
    NSLog("Tag", options["tag"])
    if (options["tag"] != nil) {
        let tag = options["tag"] as? String
    }

    MSNotificationHub.setDelegate(self)
    MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
    let deviceToken = MSNotificationHub.getPushChannel()
    let installationId =  MSNotificationHub.getInstallationId()

    if(installationId.isEmpty || deviceToken.isEmpty) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Error - register device for push first");
            NSLog("Error registering push device")
            pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            pushSelf.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    else {
        if (tag != " " && tag != nil) {
            NSLog("Add Tags to MSNotificationHub");
            MSNotificationHub.removeTag(tag);
        }  
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
