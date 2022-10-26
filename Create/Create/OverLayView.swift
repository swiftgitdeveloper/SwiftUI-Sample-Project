/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing current reminder status.
*/

import SwiftUI

struct OverLayView: View {
    
    let infoMessage: String
    
    var body: some View {
        VStack {
            Text(infoMessage)
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
           
            .padding()
            .cornerRadius(5)
        }
        .padding()
    }
}

struct OverLayView_Previews: PreviewProvider {
    static var previews: some View {
        OverLayView(infoMessage: "")
    }
}
