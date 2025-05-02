import Foundation

// MARK: - GraphQL Response Models

struct GraphQLResponse: Codable {
    let data: DataResponse?

    struct DataResponse: Codable {
        let recentAcSubmissionList: [RecentSubmission]?
        let questionSubmissionList: SubmissionListResponse?
        let question: QuestionDetails?
    }

    struct RecentSubmission: Codable {
        let title: String
        let titleSlug: String
        let timestamp: String
        let statusDisplay: String
        let lang: String
    }

    struct SubmissionListResponse: Codable {
        let submissions: [Submission]?
    }

    struct Submission: Codable {
        let id: String
        let title: String
        let statusDisplay: String
        let notes: String?
    }

    struct QuestionDetails: Codable {
        let title: String
        let difficulty: String
    }
}

// MARK: - User Problems 가져오기
struct UserProblemStatsResponse: Codable {
    let data: UserProblemStatsData?
}

struct UserProblemStatsData: Codable {
    let allQuestionsCount: [QuestionCount]
    let matchedUser: MatchedUserStats?
}

struct QuestionCount: Codable {
    let difficulty: String
    let count: Int
}

struct MatchedUserStats: Codable {
    let problemsSolvedBeatsStats: [BeatsStats]?
    let submitStatsGlobal: SubmitStatsGlobal?
}

struct BeatsStats: Codable {
    let difficulty: String
    let percentage: Double?
}

struct SubmitStatsGlobal: Codable {
    let acSubmissionNum: [SubmissionStat]
}

struct SubmissionStat: Codable {
    let difficulty: String
    let count: Int
}

// MARK: - User Status 가져오기

struct UserStatusResponse: Codable {
    let data: UserStatusData?
}

struct UserStatusData: Codable {
    let userStatus: UserStatus
}

struct UserStatus: Codable {
    let username: String
    let isSignedIn: Bool
}

// MARK: - User Profile 가져오기
struct UserPublicProfileResponse: Codable {
    let data: UserPublicProfileData?
}

struct UserPublicProfileData: Codable {
    let matchedUser: PublicUser?
}

struct PublicUser: Codable {
    let username: String
    let profile: PublicUserProfile
}

struct PublicUserProfile: Codable {
    let ranking: Int
    let postViewCount: Int
    let reputation: Int
}

// MARK: - User Calendar (Heatmap) 가져오기
struct UserCalendarResponse: Codable {
    let data: UserCalendarData?
}

struct UserCalendarData: Codable {
    let matchedUser: MatchedCalendarUser?
}

struct MatchedCalendarUser: Codable {
    let userCalendar: UserCalendar
}

struct UserCalendar: Codable {
    let activeYears: [Int]
    let streak: Int
    let totalActiveDays: Int
    let submissionCalendar: String
}

// MARK: - Leetcode Service

class LeetcodeService {
    static let shared = LeetcodeService()
    private init() {}

    private let baseURL = "https://leetcode.com/graphql"

    func getStoredLeetCodeCookies() -> (session: String?, csrf: String?) {
        (
            UserDefaults.standard.string(forKey: "leetcode_session"),
            UserDefaults.standard.string(forKey: "leetcode_csrf")
        )
    }

    func fetchCurrentUsername(completion: @escaping (String?) -> Void) {
        let query = """
        query globalData {
          userStatus {
            username
            isSignedIn
          }
        }
        """

        sendGraphQLRequest(query: query, variables: [:]) { (response: UserStatusResponse?) in
            guard let status = response?.data?.userStatus, status.isSignedIn else {
                print("❌ 로그인되어 있지 않거나 username 없음")
                completion(nil)
                return
            }
            print("✅ 로그인된 유저 이름: \(status.username)")
            completion(status.username)
        }
    }

    func fetchUserPublicProfile(username: String, completion: @escaping (PublicUser?) -> Void) {
        let query = """
        query userPublicProfile($username: String!) {
          matchedUser(username: $username) {
            username
            profile {
              ranking
              postViewCount
              reputation
            }
          }
        }
        """

        sendGraphQLRequest(query: query, variables: ["username": username]) { (response: UserPublicProfileResponse?) in
            if let user = response?.data?.matchedUser {
                completion(user)
            } else {
                print("❌ 공개 프로필 응답 실패 또는 데이터 없음")
                completion(nil)
            }
        }
    }

    func fetchUserProblemStats(username: String, completion: @escaping (UserProblemStatsData?) -> Void) {
        let query = """
        query userProblemsSolved($username: String!) {
          allQuestionsCount {
            difficulty
            count
          }
          matchedUser(username: $username) {
            problemsSolvedBeatsStats {
              difficulty
              percentage
            }
            submitStatsGlobal {
              acSubmissionNum {
                difficulty
                count
              }
            }
          }
        }
        """

        sendGraphQLRequest(query: query, variables: ["username": username]) { (response: UserProblemStatsResponse?) in
            if let data = response?.data {
                completion(data)
            } else {
                print("❌ 응답 파싱 실패 or nil 데이터")
                completion(nil)
            }
        }
    }
    
    func fetchUserCalendar(username: String, year: Int, completion: @escaping (UserCalendar?) -> Void) {
        let query = """
        query userProfileCalendar($username: String!, $year: Int) {
            matchedUser(username: $username) {
                userCalendar(year: $year) {
                    activeYears
                    streak
                    totalActiveDays
                    submissionCalendar
                }
            }
        }
        """

        let variables: [String: Any] = [
            "username": username,
            "year": year
        ]

        sendGraphQLRequest(query: query, variables: variables) { (response: UserCalendarResponse?) in
            if let calendar = response?.data?.matchedUser?.userCalendar {
                completion(calendar)
            } else {
                print("❌ 캘린더 데이터 가져오기 실패")
                completion(nil)
            }
        }
    }

    func fetchRecentSubmissions(username: String, limit: Int, completion: @escaping ([String]?) -> Void) {
        let query = """
        query getACSubmissions($username: String!, $limit: Int) {
            recentAcSubmissionList(username: $username, limit: $limit) {
                title
                titleSlug
                timestamp
                statusDisplay
                lang
            }
        }
        """

        let variables: [String: Any] = ["username": username, "limit": limit]

        sendGraphQLRequest(query: query, variables: variables) { (response: GraphQLResponse?) in
            let slugs = response?.data?.recentAcSubmissionList?.map { $0.titleSlug }
            print("✅ titleSlug 리스트: \(slugs ?? [])")
            completion(slugs)
        }
    }

    func fetchFilteredSubmissionsWithDifficulty(titleSlugList: [String], completion: @escaping ([(id: String, title: String, difficulty: String, notes: String)]) -> Void) {
        var results: [(id: String, title: String, difficulty: String, notes: String)] = []
        let group = DispatchGroup()

        for slug in titleSlugList {
            group.enter()
            fetchSubmissionsForTitleSlug(titleSlug: slug, offset: 0, limit: 20) { submissions in
                self.fetchQuestionDifficulty(titleSlug: slug) { difficulty in
                    let filtered = submissions.map { ($0.id, $0.title, difficulty ?? "Unknown", $0.notes) }
                    results.append(contentsOf: filtered)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(results)
        }
    }

    private func fetchSubmissionsForTitleSlug(titleSlug: String, offset: Int, limit: Int, completion: @escaping ([(id: String, title: String, notes: String)]) -> Void) {
        let query = """
        query submissionList($offset: Int!, $limit: Int!, $questionSlug: String!) {
          questionSubmissionList(offset: $offset, limit: $limit, questionSlug: $questionSlug) {
            submissions {
              id
              title
              statusDisplay
              notes
            }
          }
        }
        """

        let variables: [String: Any] = ["questionSlug": titleSlug, "offset": offset, "limit": limit]

        sendGraphQLRequest(query: query, variables: variables) { (response: GraphQLResponse?) in
            let filtered = response?.data?.questionSubmissionList?.submissions?
                .filter { $0.statusDisplay == "Accepted" && !($0.notes?.isEmpty ?? true) }
                .map { ($0.id, $0.title, $0.notes!) } ?? []

            print("✅ Filtered submissions for \(titleSlug): \(filtered)")
            completion(filtered)
        }
    }

    private func fetchQuestionDifficulty(titleSlug: String, completion: @escaping (String?) -> Void) {
        let query = """
        query questionTitle($titleSlug: String!) {
          question(titleSlug: $titleSlug) {
            title
            difficulty
          }
        }
        """

        sendGraphQLRequest(query: query, variables: ["titleSlug": titleSlug]) { (response: GraphQLResponse?) in
            completion(response?.data?.question?.difficulty)
        }
    }

    private func sendGraphQLRequest<T: Decodable>(query: String, variables: [String: Any], completion: @escaping (T?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("❌ 잘못된 URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (session, csrf) = getStoredLeetCodeCookies()
        
        if let session = session, let csrf = csrf {
            let cookieHeader = "LEETCODE_SESSION=\(session); csrftoken=\(csrf)"
            request.setValue(cookieHeader, forHTTPHeaderField: "Cookie")
            request.setValue(csrf, forHTTPHeaderField: "X-CSRFToken")
        } else {
            print("⚠️ 쿠키 없음. 인증이 필요할 수도 있음.")
        }

        let body: [String: Any] = ["query": query, "variables": variables]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            print("❌ JSON 직렬화 실패")
            completion(nil)
            return
        }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ 요청 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ 응답 데이터 없음")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(decoded)
            } catch {
                print("❌ JSON 디코딩 실패: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
