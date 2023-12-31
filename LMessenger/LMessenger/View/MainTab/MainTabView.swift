//
//  MainTabView.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: (selectedTab == tab)))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
    }
    
    // 선택되지 않은 탭의 색깔도 검정으로 유지하기 위해서 init으로 다음과 같이 작성
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: StubService())))
}
