import Foundation

class APIService {
    let baseUrl = "https://inui.jn.sfc.keio.ac.jp/"
    func fetchEsmState(completion: @escaping (Result<EsmState, Error>) -> Void) {
        let url = URL(string: baseUrl + "esm_active")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(EsmState.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchEsm(completion: @escaping (Result<[Esm], Error>) -> Void) {
        let url = URL(string: baseUrl + "esm")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Esm].self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func sendLabel(userId: String, esmId: Int, label: String, completion: @escaping (Result<SendLabelOverload, Error>) -> Void) {
        let url = URL(string: baseUrl + "send_label?user_id=\(userId)&esm_id=\(esmId)&label=\(label)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(SendLabelOverload.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func sendUser(userId: String, userName: String, completion: @escaping (Result<SendUserOverload, Error>) -> Void) {
        let url = URL(string: baseUrl + "send_user?user_id=\(userId)&user_name=\(userName)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(SendUserOverload.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}

struct EsmState: Codable {
    let active: Bool
}

struct Esm: Codable {
    let esm_id: Int
    let title: String
    let content: String
}

struct SendLabelOverload: Codable {
    let label: String
    let success: Bool
}

struct SendUserOverload: Codable {
    let user_id: String
    let user_name: String
    let success: Bool
}
