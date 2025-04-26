//
//  StatisticsViewController.swift
//  Qode
//
//  Created by David Lee on 4/9/25.
//
/*
import UIKit

class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Statistics"
    }
}
*/
import SwiftUI
import WebKit

struct StatisticsView: View {
    @StateObject private var presenter = StatisticsPresenter()
    @State private var showAccountDialog = false
    @State private var showLoginWebView = false
    @State private var currentQuarterStart: Date = Calendar.current.startOfQuarter(for: Date())
    @State private var recentSlugs: [String] = []

    var currentQuarterTitle: String {
        let year = Calendar.current.component(.year, from: currentQuarterStart)
        let quarter = (Calendar.current.component(.month, from: currentQuarterStart) - 1) / 3 + 1
        return "\(year) Q\(quarter)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Profile Header
                ProfileHeaderView(
                    isLinked: presenter.isLeetCodeLinked,
                    username: presenter.username,
                    rank: presenter.rank,
                    views: presenter.views,
                    reputation: presenter.reputation,
                    onAvatarTapped: {
                        showAccountDialog = true
                    },
                    onSettingTapped: {
                        print("⚙️ 설정 탭됨")
                    }
                )
                .padding(.top, 8)

                // MARK: - Solved Problems
                VStack(alignment: .leading, spacing: 16) {
                    Text("Solved Problems")
                        .font(.headline)

                    HStack(alignment: .center, spacing: 16) {
                        ZStack {
                            let totalCount = presenter.totalCount
                            let solvedCount = presenter.solvedCount
                            let progress = totalCount > 0 ? Double(solvedCount) / Double(totalCount) : 0.0

                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                .frame(width: 70, height: 70)

                            Circle()
                                .trim(from: 0.0, to: CGFloat(progress))
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 70, height: 70)

                            VStack(spacing: 2) {
                                Text("\(solvedCount)")
                                    .font(.headline)
                                Text("of \(totalCount)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }

                        // 난이도별 통계 + 평균 시간
                        VStack(alignment: .leading, spacing: 8) {
                            StatBar(
                                title: "Easy",
                                current: presenter.easySolved,
                                total: presenter.easyTotal,
                                averageTime: presenter.easyAverageTime
                            )
                            StatBar(
                                title: "Medium",
                                current: presenter.mediumSolved,
                                total: presenter.mediumTotal,
                                averageTime: presenter.mediumAverageTime
                            )
                            StatBar(
                                title: "Hard",
                                current: presenter.hardSolved,
                                total: presenter.hardTotal,
                                averageTime: presenter.hardAverageTime
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // MARK: - Heatmap Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Activity Heatmap")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 16) {
                            Button(action: {
                                let prev = Calendar.current.date(byAdding: .month, value: -3, to: currentQuarterStart) ?? currentQuarterStart
                                let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
                                if prev >= Calendar.current.startOfQuarter(for: oneYearAgo) {
                                    currentQuarterStart = prev
                                }
                            }) {
                                Image(systemName: "chevron.left")
                            }
                            .disabled(
                                Calendar.current.date(byAdding: .month, value: -3, to: currentQuarterStart)! < Calendar.current.startOfQuarter(for: Calendar.current.date(byAdding: .year, value: -1, to: Date())!)
                            )

                            Text(currentQuarterTitle)
                                .font(.caption)

                            Button(action: {
                                if let next = Calendar.current.date(byAdding: .month, value: 3, to: currentQuarterStart),
                                   next <= Date() {
                                    currentQuarterStart = next
                                }
                            }) {
                                Image(systemName: "chevron.right")
                            }
                            .disabled(Calendar.current.date(byAdding: .month, value: 3, to: currentQuarterStart)! > Date())
                        }
                    }
                    .padding(.horizontal)

                    let quarterRange = Calendar.current.quarterRange(for: currentQuarterStart)
                    let filteredData = presenter.heatmapData.filter { date, _ in
                        quarterRange.contains(date)
                    }

                    LeetCodeHeatmapView(
                        calendarData: filteredData,
                        totalSubmissions: presenter.totalSubmissionCount,
                        totalActiveDays: presenter.totalActiveDays,
                        maxStreak: presenter.maxStreak,
                        quarterRange: quarterRange
                    )
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .padding(.horizontal)
                }
                
                // MARK: - Quiz Statistics
                QuizStatisticsView(presenter: presenter)
                    .padding(.top, 8)

                Spacer()
            }
        }
        .onAppear {
            presenter.checkLeetCodeLoginStatus()
        }
        .navigationTitle("Statistics")
        .confirmationDialog("",
            isPresented: $showAccountDialog,
            titleVisibility: .visible
        ) {
            if presenter.isLeetCodeLinked {
                Button("로그아웃", role: .destructive) {
                    clearLeetCodeCookies {
                        presenter.logoutFromLeetCode()
                    }
                }
            } else {
                Button("연동하기") {
                    showLoginWebView = true
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            if presenter.isLeetCodeLinked {
                Text("LeetCode에서 로그아웃 하시겠습니까?")
            } else {
                Text("계정을 연동하여 통계를 확인해보세요.")
            }
        }
        .sheet(isPresented: $showLoginWebView, onDismiss: {
            presenter.checkLeetCodeLoginStatus()
        }) {
            LoginWebView()
                .id(UUID())
        }
    }
    private func LoginWebView() -> some View {
        NavigationView {
            SafariWebViewContainer(onLoginDetected: {
                showLoginWebView = false
                presenter.checkLeetCodeLoginStatus()
            })
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("LeetCode 로그인", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                showLoginWebView = false
            })
        }
    }
}

// MARK: - WebView Inline 구현
struct SafariWebViewContainer: UIViewRepresentable {
    var onLoginDetected: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoginDetected: onLoginDetected)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        // ✅ LeetCode 관련 쿠키 삭제 후 로그인 페이지 로드
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            let leetcodeRecords = records.filter { $0.displayName.contains("leetcode") }
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: leetcodeRecords) {
                print("✅ WebView 초기 쿠키 제거 완료")

                if let url = URL(string: "https://leetcode.com/accounts/login/") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
            }
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var onLoginDetected: () -> Void

        init(onLoginDetected: @escaping () -> Void) {
            self.onLoginDetected = onLoginDetected
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                var hasSession = false
                for cookie in cookies {
                    if cookie.name == "LEETCODE_SESSION" {
                        UserDefaults.standard.set(cookie.value, forKey: "leetcode_session")
                        print("✅ LEETCODE_SESSION 저장됨")
                        hasSession = true
                    }
                    if cookie.name == "csrftoken" {
                        UserDefaults.standard.set(cookie.value, forKey: "leetcode_csrf")
                        print("✅ csrftoken 저장됨")
                    }
                }

                if hasSession {
                    LeetcodeService.shared.fetchCurrentUsername { username in
                        if let username = username {
                            UserDefaults.standard.set(username, forKey: "leetcode_username")
                            print("✅ Username 저장 완료: \(username)")
                        } else {
                            print("❌ Username 가져오기 실패")
                        }
                        DispatchQueue.main.async {
                            self.onLoginDetected()
                        }
                    }
                }
            }
        }
    }
}


func clearLeetCodeCookies(completion: @escaping () -> Void) {
    let dataStore = WKWebsiteDataStore.default()
    dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
        let leetcodeRecords = records.filter { $0.displayName.contains("leetcode") }
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: leetcodeRecords) {
            print("✅ LeetCode 쿠키 삭제 완료")
            completion()
        }
    }
}

struct ProfileHeaderView: View {
    var isLinked: Bool
    var username: String
    var rank: Int
    var views: Int
    var reputation: Int
    var onAvatarTapped: () -> Void
    var onSettingTapped: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button("SETTING", action: onSettingTapped)
                    .font(.caption)
                    .foregroundColor(.black)
            }

            HStack(alignment: .center, spacing: 8) {
                VStack(spacing: 6) {
                    Button(action: onAvatarTapped) {
                        LeetCodeProfileIcon(isLinkedToLeetCode: isLinked)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text(username)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                Spacer()

                HStack(spacing: 12) {
                    StatMetric(value: rank, title: "Rank")
                    StatMetric(value: views, title: "Views")
                    StatMetric(value: reputation, title: "Reputation")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3))
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Subviews
struct LeetCodeProfileIcon: View {
    var isLinkedToLeetCode: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 사용자 원형 아바타
            Circle()
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .padding(18)
                        .foregroundColor(isLinkedToLeetCode ? Color.orange : Color.gray)
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(isLinkedToLeetCode ? Color.orange : Color.gray.opacity(0.5), lineWidth: 3)
                )

            // 작은 LeetCode 원형 로고
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(isLinkedToLeetCode ? Color.orange : Color.gray.opacity(0.4), lineWidth: 2)
                    )

                Image("LeetcodeLogo")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .offset(x: 4, y: 4)
        }
    }
}

struct StatMetric: View {
    var value: Int
    var title: String

    var body: some View {
        VStack(spacing: 4) {
            // 숫자
            Text("\(value)")
                .font(.title3)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(height: 24) // ✅ 고정 높이 부여로 아래 텍스트 위치 유지

            // 레이블
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .fixedSize()
        }
        .frame(minWidth: 60, maxWidth: .infinity)
    }
}

struct StatBar: View {
    var title: String
    var current: Int
    var total: Int
    var averageTime: TimeInterval?  // 초 단위로 옵셔널

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(current) / CGFloat(total)
    }

    private var formattedAvg: String {
        guard let t = averageTime else { return "Unavailable" }
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%dm %02ds", m, s)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(title) \(current) / \(total)")
                    .font(.caption)
                Spacer(minLength: 8)
                Text("Avg \(formattedAvg)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 8)
                    .foregroundColor(.gray.opacity(0.2))

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: progress * 160, height: 8)
                    .foregroundColor(color(for: title))
            }
        }
    }

    private func color(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy":   return .green
        case "medium": return .orange
        case "hard":   return .red
        default:       return .black
        }
    }
}

extension Calendar {
    func startOfQuarter(for date: Date) -> Date {
        let month = ((component(.month, from: date) - 1) / 3) * 3 + 1
        return self.date(from: DateComponents(year: component(.year, from: date), month: month, day: 1))!
    }

    func quarterRange(for startOfQuarter: Date) -> ClosedRange<Date> {
        let end = date(byAdding: .month, value: 3, to: startOfQuarter)!
        return startOfQuarter...date(byAdding: .day, value: -1, to: end)!
    }
    
    func isInLastYear(quarterStart: Date) -> Bool {
        guard let oneYearAgo = self.date(byAdding: .year, value: -1, to: Date()) else { return true }
        return quarterStart >= startOfQuarter(for: oneYearAgo)
    }
}

fileprivate extension TimeInterval {
  /// “Xm Ys” 형태로 반환
  var mmss: String {
    let m = Int(self) / 60
    let s = Int(self) % 60
    return "\(m)m \(s)s"
  }
}

#Preview{
    NavigationView {
        StatisticsView()
    }
}
