//
//  ContentView.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var srcListVM = SearchListViewModel()
    @State private var searchText: String = ""
    @State private var searchCurrentPage: Int = 1
    @State private var isNextScreen = false
    @State private var selectedItem: String = ""

    func onClickSelect(userName: String) {
        isNextScreen = true
        selectedItem = userName
    }

    var ListHorizontal: some View {
        ForEach (Array(srcListVM.usersPrevDataLists.enumerated()), id: \.offset) { index , data in
            Button(action: {onClickSelect(userName: data.userNames)}) {
                HStack {
                    AsyncImage(url: data.avatar ??  URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqMPcJQL6w3hvPkjyFZNOOqyoxwMxJ_GGs_w&usqp=CAU")
                            , content: { image in
                        image.resizable()
                             .scaledToFill()
                             .clipShape(Circle())
                             .frame(width: 80, height: 80)
                        }, placeholder: {
                        ProgressView()
                    })
                    Spacer().frame(width:5)
                    Text(data.userNames)
                        .font(.title2.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                    Spacer().frame(width: 5)
                }
            }
                        
            if(index == srcListVM.usersPrevDataLists.count - 1 && srcListVM.pageTotalCurrent != srcListVM.usersPrevDataLists.count){
                Button(action: {
                    async {
                            searchCurrentPage = searchCurrentPage + 1
                            await srcListVM.search(name: searchText, page: (searchCurrentPage), loadMore: true)
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

    var ListComponent: some View {
        VStack{
                List {
                    ListHorizontal
                }
                    .listStyle(.plain)
                    .searchable(text: $searchText)
                    .onChange(of: searchText) { [searchText] value in
                        var prevText = [searchText]
                        srcListVM.isNotFound = false
                        if value.isEmpty{
                            srcListVM.usersPrevDataLists.removeAll()
                        }
                    }
                    .overlay(Group{
                        if(srcListVM.isNotFound && !searchText.isEmpty){
                            Text("Not found")
                                .font(.title2.weight(.bold))
                        }
                    })
                    .onSubmit(of: .search) {
                        async {
                            await srcListVM.search(name: searchText, page: searchCurrentPage, loadMore: false)
                        }
                    }
                
                    .navigationTitle("Users")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: UserDetailsView(selectedUser: SelectedUser(name: selectedItem)), isActive: $isNextScreen) {EmptyView()}
                ListComponent
            }
            .refreshable {
                if(!searchText.isEmpty){
                    srcListVM.usersPrevDataLists = []
                    srcListVM.usersDataLists = []
                    searchCurrentPage = 1
                    async {
                        await srcListVM.search(name: searchText, page: searchCurrentPage, loadMore: false)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
