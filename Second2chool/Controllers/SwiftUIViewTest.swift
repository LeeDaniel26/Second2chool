//
//  SwiftUIViewTest.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/11/19.
//

import SwiftUI

struct SwiftUIViewTest: View {
    var body: some View {
        VStack {
            HStack {
                Text("SwiftUI Screen")
                    .bold()
                    .font(.system(size: 21.0))
            }
            Spacer()
                .frame(width: 1, height: 74, alignment: .bottom)
            VStack(alignment: .center){
                Button(action: {
                }) {
                    Text("Navigate to UIKit Screen")
                        .font(.system(size: 21.0))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width, height: 10, alignment: .center)
                }
            }
            Spacer()
                .frame(width: 2, height: 105, alignment: .bottom)
        }.navigationBarHidden(true)
    }
}

struct SwiftUIViewTest_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewTest()
    }
}
