//
//  LandingPage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/9/22.
//

import Foundation
import SwiftUI
import CoreData



struct LandingPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var nextPage: Bool = false
    
    var body: some View {
        NavigationStack{
            
            
            VStack{
                Text("Welcome back, user!")
                Button {
                    nextPage = true
                } label: {
                    Text("Create Note")
                }
            }.navigationDestination(isPresented: $nextPage) {
                NotePage()
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LandingPage()
        }
    }
}
