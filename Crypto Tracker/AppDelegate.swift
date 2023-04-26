//
//  AppDelegate.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import SwiftUI
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    
    let popover = NSPopover()
    
    lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
    }
}




extension AppDelegate {
    func setupMenuBar(){
        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        guard
            let contentView = self.contentView,
            let menuButton = statusItem.button else {
            return
        }
        
        let hostingView = NSHostingView(rootView: MenuBarCoinView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
     ])
        
        menuButton.action = #selector(menuBarClicked)
        
    }
    
    @objc func menuBarClicked() {
        setupPopOver()
        if popover.isShown {
            popover.performClose(nil)
            return
        }
            guard let menuButton = statusItem.button else {
                return
            }
        
        let positioningView = NSView(frame: menuButton.bounds)
        positioningView.identifier = NSUserInterfaceItemIdentifier("positioningView")
        menuButton.addSubview(positioningView)
        popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
        
        menuButton.bounds = menuButton.bounds.offsetBy(dx: 0, dy: menuButton.bounds.height)
        
        popover.contentViewController?.view.window?.makeKey()
    }
}


extension AppDelegate: NSPopoverDelegate {
    func setupPopOver() {
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 240, height: 280)
        popover.contentViewController = NSViewController()
        
        popover.contentViewController?.view = NSHostingView(rootView: PopOverCoinView().frame(maxWidth: .infinity, maxHeight: .infinity))
        popover.delegate = self
    }
    
    func popoverDidClose(_ notification: Notification) {
        let positioningView = statusItem.button?.subviews.first {
            $0.identifier == NSUserInterfaceItemIdentifier("positioningView")
            
        }
        
        positioningView?.removeFromSuperview()
    }
    
}
