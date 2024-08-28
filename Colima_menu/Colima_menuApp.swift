//
//  Colima_menuApp.swift
//  Colima_menu
//
//  Created by Luboš Renner on 27.08.2024.
//

import SwiftUI

@main
struct Colima_menuApp: App {
    @State var status : Bool = false
    
    var body: some Scene {
        MenuBarExtra("Colima Menu", systemImage: status ? "arkit" : "multiply")
        {
            AppMenu(status : $status)
        }
    }
    
    struct AppMenu: View {
        func action1() {
            _ = run(with: "colima start")
            getState()
        }
        func action2() {
            _ = run(with: "colima stop")
            getState()
        }
        func closeApp() { exit(EXIT_SUCCESS) }
        
        @Binding var status : Bool

        
        var body: some View {
            let _ = getState()
            Button(action: action1, label: { Text("Start Colima") })
            Button(action: action2, label: { Text("Stop Colima") })
            Divider()
            Button(action: closeApp, label: { Text("Quit")})
        }
 
        func getState() {
            let state : String = run(with: "colima status")
            if state.contains("is running") {
                status = true
            } else {
                status = false
            }
        }
        
        func run(with args: String...) -> String {
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/bin/zsh")
            
            var env = ProcessInfo.processInfo.environment
            var path = env["PATH"]! as String
            path = "/opt/homebrew/bin:" + path
            env["PATH"] = path
            task.environment = env
            
            task.arguments = ["-c", args.joined(separator: " ")]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
            
            try! task.run()
            
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

            return(output)
        }
    }
}
