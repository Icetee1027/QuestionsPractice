import Foundation

struct QuestionInfo: Codable {
    let subject: String
    let difficulty: String
    let question_type: String
}

struct QuestionTypeDetector: Decodable {
    let questionType: String
    
    enum CodingKeys: String, CodingKey {
        case questionType = "question_type"
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case unknownType
}

class QuestionAPI {
    static let shared = QuestionAPI()
    private init() {}
    
    func generateQuestion(info: QuestionInfo, completion: @escaping (Result<any QuestionProtocol, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.0.103:8080/generate-question") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(info)
            //print("API Request Data: \(String(data: jsonData, encoding: .utf8) ?? "")")
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            //print("API Response Data: \(String(data: data, encoding: .utf8) ?? "")")
            
            do {
                let detector = try JSONDecoder().decode(QuestionTypeDetector.self, from: data)
                //print("Detected Question Type: \(detector.questionType)")
                
                // 加入 subject 和 difficulty
                var jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                jsonObject?["id"] = UUID().uuidString
                jsonObject?["subject"] = info.subject
                jsonObject?["difficulty"] = info.difficulty
                let modifiedData = try JSONSerialization.data(withJSONObject: jsonObject ?? [:])
                
                // Debug：查看修改過的資料
                //print("Modified Data: \(String(data: modifiedData, encoding: .utf8) ?? "")")
                
                let result: any QuestionProtocol
                switch detector.questionType {
                case "單選題", "多選題", "是非題", "填空題", "簡答題":
                    result = try JSONDecoder().decode(BaseQuestion.self, from: modifiedData)
                case "配對題":
                    result = try JSONDecoder().decode(MatchingQuestion.self, from: modifiedData)
                case "閱讀題組":
                    result = try JSONDecoder().decode(ReadingQuestion.self, from: modifiedData)
                default:
                    completion(.failure(APIError.unknownType))
                    return
                }
                
                //print("Decoded \(detector.questionType)")
                completion(.success(result))
                
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
