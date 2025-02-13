import SwiftUI

// Main View - Shows user list
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isGridView {
                    gridView
                } else {
                    listView
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                        Image(systemName: "rectangle.grid.1x2.fill")
                            .tag(true)
                            .accessibilityLabel(Text("Grid view"))

                        Image(systemName: "list.bullet")
                            .tag(false)
                            .accessibilityLabel(Text("List view"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.reloadUsers()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }

    private var listView: some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                HStack {
                    AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading) {
                        Text("\(user.name.first) \(user.name.last)")
                            .font(.headline)
                        Text(user.dob.date)
                            .font(.subheadline)
                    }
                }
            }
            .onAppear {
                if viewModel.shouldLoadMoreData(currentItem: user) {
                    viewModel.fetchUsers()
                }
            }
        }
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack {
                            AsyncImage(url: URL(string: user.picture.medium)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }

                            Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

// Show users details
struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.picture.large)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text("\(user.dob.date)")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}

