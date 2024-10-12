//
//  Disclaimer.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 16/4/24.
//

import SwiftUI

struct Disclaimer: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("This application processes user data through third-party servers. We do not assume responsibility for any consequences arising from the processing of personal data on these servers. Users are advised to review the privacy policies and terms of service of these third-party providers.Furthermore, the content provided within this application is for informational purposes only and does not constitute professional advice. We do not endorse, guarantee, or assume responsibility for the accuracy, reliability, or suitability of any information, product, or service provided through this application. Users are solely responsible for their interactions and use of this application. Any reliance on the content within this application is at the user's own risk. We explicitly disclaim any liability for damages, including but not limited to, incidental, consequential, or punitive damages, arising from the use or inability to use this application. By using this application, you agree to indemnify and hold harmless the developers, contributors, and affiliates from any claims, damages, or losses, including legal fees, arising out of your use of the application or violation of these terms. Please use this application responsibly and exercise caution when sharing personal information or relying on the provided content.")
            }
        }
        .frame(maxWidth:350)
    }
}

#Preview {
    Disclaimer()
}
