//
//  AnnouncementRow.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import SwiftUI

struct AnnouncementRow: View {
    var landmark: Announcement


    var body: some View {
        HStack{
            if !landmark.sf.isEmpty{
                Image(systemName: landmark.sf)
            }else{
                Image(systemName: "multiply.circle.fill")
            }
            VStack{
                HStack{
                    Text(landmark.title)
                        .bold()
                    Spacer()
                }
                
                HStack{
                    Text("Announced by \(landmark.author)")
                        .foregroundStyle(Color(.gray))
                                            
                    Spacer()
                }
                
                
                
            }
        }

        }
    }


