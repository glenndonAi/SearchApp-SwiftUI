//
//  FollowsView.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import SwiftUI

struct FollowsView: View {

    var followData: ToFollow
    @StateObject private var followListVM = FollowListViewModel()
    @State private var followListCurrentPage: Int = 1


    var ListHorizontal: some View {
        ForEach (Array(followListVM.userFollowPrevDataLists.enumerated()), id: \.offset) { index , data in
            HStack {
                AsyncImage(url: data.avatar ??  URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqMPcJQL6w3hvPkjyFZNOOqyoxwMxJ_GGs_w&usqp=CAU")
                        , content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100)
                    }, placeholder: {
                    ProgressView()
                })
                    .cornerRadius(20)
                    Spacer().frame(width:5)
                    Text(data.userNames)
                        .font(.title2.weight(.semibold))
                    Spacer().frame(width: 5)
                }
                        
            if(index == followListVM.userFollowPrevDataLists.count - 1
                && followData.followCount != followListVM.userFollowPrevDataLists.count){
                Button(action: {
                    async {
                            followListCurrentPage = followListCurrentPage + 1
                            
                            await followListVM.search(name: followData.selectedUser,
                                page: (followListCurrentPage), loadMore: true, isFollowing: followData.isItFollowing)
                        }
                    }) {
                        HStack{
                            Spacer()
                            Text("Load More")
                            Spacer()
                        }
                    }
                    .padding(.all)
                }
            }
    }
    
    var body: some View {
        VStack{
                List {
                    ListHorizontal
                }
                    .listStyle(.plain)
        }
        .onAppear(){

            async {
                await followListVM.search(name: followData.selectedUser,
                    page: 1, loadMore: true, isFollowing: followData.isItFollowing)
            }

        }
        .navigationTitle("Followers")
        .refreshable {
                followListVM.userFollowPrevDataLists = []
                followListVM.userFollowDataLists = []
            async {
                await followListVM.search(name: followData.selectedUser,
                    page: 1, loadMore: true, isFollowing: followData.isItFollowing)
            }
        }

    }
}

struct FollowsView_Previews: PreviewProvider {
    static let followsPreview = ToFollow(isItFollowing: true, selectedUser: "est", followCount: 0)
    static var previews: some View {
        FollowsView(followData: followsPreview)
    }
}
