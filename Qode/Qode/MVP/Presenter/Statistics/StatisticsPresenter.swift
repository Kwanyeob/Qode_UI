import Foundation
import Combine

class StatisticsPresenter: ObservableObject {
    private let leetcodeService = LeetcodeService.shared

    // MARK: - Profile & Stats
    @Published var isLeetCodeLinked = false

    @Published var username = ""
    @Published var rank = 0
    @Published var views = 0
    @Published var reputation = 0

    @Published var totalCount = 0
    @Published var solvedCount = 0

    @Published var easySolved = 0
    @Published var mediumSolved = 0
    @Published var hardSolved = 0

    @Published var easyTotal = 0
    @Published var mediumTotal = 0
    @Published var hardTotal = 0

    // MARK: - Heatmap
    @Published var heatmapData: [Date: Int] = [:]
    @Published var totalSubmissionCount = 0
    @Published var totalActiveDays = 0
    @Published var maxStreak = 0

    // MARK: - 평균 시간 (TimeInterval)
    @Published var easyAverageTime: TimeInterval? = nil
    @Published var mediumAverageTime: TimeInterval? = nil
    @Published var hardAverageTime: TimeInterval? = nil
    
    // MARK: - Quiz 통계
    @Published var quizWeeklyScores: [String: Int] = [
        "Mon": 66, "Tue": 99, "Wed": 33, "Thu": 99, "Fri": 66, "Sat": 66, "Sun": 33
    ]
    @Published var quizSolvedCount = 10
    @Published var quizLongestStreak = 5
    @Published var quizAccuracyRate: Double = 0.33 // 0.0 ~ 1.0
    @Published var quizRankTopPercent = 20 // 예: 10 -> Top 10%

    init() {
        checkLeetCodeLoginStatus()
    }

    func checkLeetCodeLoginStatus() {
        let (session, csrf) = leetcodeService.getStoredLeetCodeCookies()
        isLeetCodeLinked = (session != nil && csrf != nil)
        if isLeetCodeLinked {
            loadAllStats()
        }
    }

    private func loadAllStats() {
        guard let stored = UserDefaults.standard.string(forKey: "leetcode_username") else { return }
        username = stored

        fetchStatistics()
        fetchSubmissionTimes()
        fetchHeatmap()
    }

    // MARK: - 1) 기본 통계
    private func fetchStatistics() {
        leetcodeService.fetchUserProblemStats(username: username) { [weak self] data in
            guard let self = self, let stats = data else { return }
            DispatchQueue.main.async {
                let allCounts = stats.allQuestionsCount.reduce(into: [String:Int]()) {
                    $0[$1.difficulty.lowercased()] = $1.count
                }
                self.totalCount    = allCounts["all"] ?? 0
                self.easyTotal     = allCounts["easy"] ?? 0
                self.mediumTotal   = allCounts["medium"] ?? 0
                self.hardTotal     = allCounts["hard"] ?? 0

                let acs = stats.matchedUser?
                    .submitStatsGlobal?
                    .acSubmissionNum
                    .reduce(into: [String:Int]()) { $0[$1.difficulty.lowercased()] = $1.count }
                    ?? [:]

                self.solvedCount   = acs["all"] ?? 0
                self.easySolved    = acs["easy"] ?? 0
                self.mediumSolved  = acs["medium"] ?? 0
                self.hardSolved    = acs["hard"] ?? 0
            }
        }

        leetcodeService.fetchUserPublicProfile(username: username) { [weak self] resp in
            guard let self = self, let profile = resp?.profile else { return }
            DispatchQueue.main.async {
                self.rank       = profile.ranking
                self.views      = profile.postViewCount
                self.reputation = profile.reputation
            }
        }
    }

    // MARK: - 2) Heatmap 통계
    private func fetchHeatmap() {
        let year = Calendar.current.component(.year, from: Date())
        leetcodeService.fetchUserCalendar(username: username, year: year) { [weak self] cal in
            guard let self = self, let cal = cal else { return }
            DispatchQueue.main.async {
                self.totalActiveDays     = cal.totalActiveDays
                self.maxStreak           = cal.streak

                guard let data = cal.submissionCalendar
                        .data(using: .utf8),
                      let dict = try? JSONDecoder()
                        .decode([String:Int].self, from: data)
                else { return }

                self.totalSubmissionCount = dict.values.reduce(0, +)
                var map: [Date:Int] = [:]
                dict.forEach { key, count in
                    if let ts = Double(key) {
                        let day = Date(timeIntervalSince1970: ts).startOfDay
                        map[day] = count
                    }
                }
                self.heatmapData = map
            }
        }
    }

    // MARK: - 3) 제출 시간 평균
    private func fetchSubmissionTimes() {
        leetcodeService.fetchRecentSubmissions(username: username, limit: 20) { [weak self] slugs in
            guard let self = self, let list = slugs, !list.isEmpty else { return }

            self.leetcodeService.fetchFilteredSubmissionsWithDifficulty(titleSlugList: list) { subs in
                var easySecs:   [TimeInterval] = []
                var mediumSecs: [TimeInterval] = []
                var hardSecs:   [TimeInterval] = []

                let pattern = #"Time taken:\s*(\d+)\s*m\s*(\d+)\s*s"#
                let regex = try? NSRegularExpression(pattern: pattern)

                for (_, _, diff, notes) in subs {
                    guard let r = regex?.firstMatch(in: notes,
                                                    options: [],
                                                    range: NSRange(notes.startIndex..., in: notes)) else { continue }

                    let ns = notes as NSString
                    let m = Double(ns.substring(with: r.range(at: 1))) ?? 0
                    let s = Double(ns.substring(with: r.range(at: 2))) ?? 0
                    let total = m * 60 + s

                    switch diff.lowercased() {
                    case "easy":   easySecs.append(total)
                    case "medium": mediumSecs.append(total)
                    case "hard":   hardSecs.append(total)
                    default: break
                    }
                }

                DispatchQueue.main.async {
                    self.easyAverageTime   = Self.computeAverage(easySecs)
                    self.mediumAverageTime = Self.computeAverage(mediumSecs)
                    self.hardAverageTime   = Self.computeAverage(hardSecs)
                }
            }
        }
    }

    private static func computeAverage(_ arr: [TimeInterval]) -> TimeInterval? {
        guard !arr.isEmpty else { return nil }
        return arr.reduce(0, +) / Double(arr.count)
    }

    // 로그아웃
    func logoutFromLeetCode() {
        ["leetcode_session","leetcode_csrf","leetcode_username"].forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
        isLeetCodeLinked = false
        // 초기화
        username = ""
        rank = 0; views = 0; reputation = 0
        totalCount = 0; solvedCount = 0
        easySolved = 0; mediumSolved = 0; hardSolved = 0
        easyTotal = 0; mediumTotal = 0; hardTotal = 0
        heatmapData = [:]; totalSubmissionCount = 0
        totalActiveDays = 0; maxStreak = 0
        easyAverageTime = nil
        mediumAverageTime = nil
        hardAverageTime = nil
    }
}
