//
//  LaunchView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/21/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var permissionsComplete: Bool = UserDefaults.standard.bool(forKey: "permissions")
    
    var body: some View {
        
        if permissionsComplete {
            return AnyView(DemoList())
        } else {
            return AnyView(Permissions(permissionsComplete:$permissionsComplete))
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
