//
//  UserDetailsView.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import SwiftUI

struct UserDetailsView: View {
    @StateObject private var srcDetailsVM = UserDetailViewModel()
    @State private var isNextScreen = false
    @State private var isFollowing = false
    @State private var followCount = 0

    var selectedUser: SelectedUser


    func onClickSelect(isFollowing: Bool) {
        isNextScreen = true
        self.isFollowing = isFollowing
        followCount = isFollowing ?
            (srcDetailsVM.usersDataDetails?.followingCount ?? 0) : (srcDetailsVM.usersDataDetails?.followerCount ?? 0)
        print("srcDetailsVM", srcDetailsVM.usersDataDetails)

    }

    var RowView: some View {
        VStack{
            HStack{
                Button(action: {onClickSelect(isFollowing: false)}) {
                    Text("\(srcDetailsVM.usersDataDetails?.followerCount ?? 0) Followers")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                }
                .disabled(srcDetailsVM.usersDataDetails?.followerCount == 0)

                Text(" ~ ")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.black)
                Button(action: {onClickSelect(isFollowing: true)}) {
                    Text("\(srcDetailsVM.usersDataDetails?.followingCount ?? 0) Following")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                }
                .disabled(srcDetailsVM.usersDataDetails?.followingCount == 0)
            }
        }
        .padding(.vertical, 10)
    }

    var body: some View {
        VStack{
            NavigationLink(destination: FollowsView(followData: ToFollow(isItFollowing: isFollowing,
                selectedUser: selectedUser.name, followCount: followCount)), isActive: $isNextScreen) {EmptyView()}
  
            Spacer().frame(height: 10)
            
            AsyncImage(url: srcDetailsVM.usersDataDetails?.avatar ??  URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqMPcJQL6w3hvPkjyFZNOOqyoxwMxJ_GGs_w&usqp=CAU")
                , content: { image in
                    image.resizable()
                         .scaledToFill()
                         .clipShape(Circle())
                         .frame(width: 150, height: 150)
                    }, placeholder: {
                        ProgressView()
                    })
            
            Spacer().frame(height: 12)
            
            Text(srcDetailsVM.usersDataDetails?.name ?? "N/A")
                .font(.title.weight(.bold))
                .padding(.horizontal, 2)
            
            Spacer().frame(height: 6)
            
            Text(srcDetailsVM.usersDataDetails?.userNames ?? "N/A")
                .font(.title3.weight(.medium))
                .padding(.horizontal, 13)

            RowView
            
            Text(srcDetailsVM.usersDataDetails?.description ?? "N/A")
                .font(.body.weight(.medium))
                .padding(.horizontal, 13)
            Spacer()
        }
            .onAppear(){

                async {
                    await srcDetailsVM.search(name: selectedUser.name)
                }
            }
            .navigationTitle("Details")
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static let userPreview = SelectedUser(name: "test")
    static var previews: some View {
        UserDetailsView(selectedUser: userPreview)
    }
}
