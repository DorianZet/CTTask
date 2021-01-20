//
//  NetworkManagerTests.swift
//  CodeaddictTaskTests
//
//  Created by Mateusz Zacharski on 20/01/2021.
//

import XCTest
@testable import CodeaddictTask
class NetworkManagerTests: XCTestCase {
    
    var sut = NetworkManager.shared
    
    var mockSession: MockURLSession!
    
    var imgMockSession: MockURLSession!
    
    override func tearDown() {
        mockSession = nil
        imgMockSession = nil
        super.tearDown()
    }
    
   // MARK: - MOCK TESTS
    
    func test_getRepos_success() {
        mockSession = createJSONMockSession(fromJsonFile: "Repos", andStatusCode: 200, andError: nil)
                
        sut.getRepos(withSession: mockSession, for: "windows", page: 1) { (result) in
            
            switch result {
            case .success(let repos):
                XCTAssertEqual(repos.count, NetworkManager.numberOfObjectsFetched)
                XCTAssertEqual(repos[0].name, "shadowsocks-windows")
                
            case .failure(_):
                XCTFail("Something went wrong, this test case should be successful.")
            }
        }
    }
    
    func test_getRepos_offlineError() {
        let offlineError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        
        mockSession = createJSONMockSession(fromJsonFile: "Repos", andStatusCode: 0, andError: offlineError)
                
        sut.getRepos(withSession: mockSession, for: "windows", page: 1) { (result) in
            
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.unableToComplete)
            }
        }
    }
    
    func test_getRepos_incorrectResponseCode() {
        mockSession = createJSONMockSession(fromJsonFile: "Articles123", andStatusCode: 404, andError: nil)
                
        sut.getRepos(withSession: mockSession, for: "windows", page: 1) { (result) in
            
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.invalidResponse)
            }
        }
    }
    
    func test_getRepos_incorrectData() {
        mockSession = createJSONMockSession(fromJsonFile: "ABCD", andStatusCode: 200, andError: nil)
                
        sut.getRepos(withSession: mockSession, for: "windows", page: 1) { (result) in
            
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.invalidData)
            }
        }
    }
    
    func test_get3Commits_success() {
        mockSession = createJSONMockSession(fromJsonFile: "Commits", andStatusCode: 200, andError: nil)
                
        sut.getFirstThreeCommits(withSession: mockSession, from: Repo(name: "dummy", stargazersCount: 0, commitsUrl: "dummy", url: "dummy", htmlUrl: "dummy", owner: RepoAuthor(login: "dummy", id: 0, avatarUrl: "dummy"))) { (result) in
            switch result {
            case .success(let commits):
                XCTAssertEqual(commits.count, 3)
                XCTAssertEqual(commits[0].commit.committer.name, "DorianZet")
                
            case .failure(_):
                XCTFail("Something went wrong, this test case should be successful.")
            }
        }
    }
    
    func test_get3Commits_offlineError() {
        let offlineError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)

        mockSession = createJSONMockSession(fromJsonFile: "Commits", andStatusCode: 0, andError: offlineError)
        
        sut.getFirstThreeCommits(withSession: mockSession, from: Repo(name: "dummy", stargazersCount: 0, commitsUrl: "dummy", url: "dummy", htmlUrl: "dummy", owner: RepoAuthor(login: "dummy", id: 0, avatarUrl: "dummy"))) { (result) in
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.unableToComplete)
            }
        }
    }
    
    func test_getCommits_incorrectResponseCode() {
        mockSession = createJSONMockSession(fromJsonFile: "Commits", andStatusCode: 404, andError: nil)
                
        sut.getFirstThreeCommits(withSession: mockSession, from: Repo(name: "dummy", stargazersCount: 0, commitsUrl: "dummy", url: "dummy", htmlUrl: "dummy", owner: RepoAuthor(login: "dummy", id: 0, avatarUrl: "dummy"))) { (result) in
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.invalidResponse)
            }
        }
    }
    
    func test_getCommits_responseCode409() {
        mockSession = createJSONMockSession(fromJsonFile: "Commits", andStatusCode: 409, andError: nil)
                
        sut.getFirstThreeCommits(withSession: mockSession, from: Repo(name: "dummy", stargazersCount: 0, commitsUrl: "dummy", url: "dummy", htmlUrl: "dummy", owner: RepoAuthor(login: "dummy", id: 0, avatarUrl: "dummy"))) { (result) in
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.commitsEmpty)
            }
        }
    }
    
    func test_getCommits_incorrectData() {
        mockSession = createJSONMockSession(fromJsonFile: "ABCD", andStatusCode: 200, andError: nil)
                
        sut.getFirstThreeCommits(withSession: mockSession, from: Repo(name: "dummy", stargazersCount: 0, commitsUrl: "dummy", url: "dummy", htmlUrl: "dummy", owner: RepoAuthor(login: "dummy", id: 0, avatarUrl: "dummy"))) { (result) in
            switch result {
            case .success(_):
                XCTFail("Something went wrong, this test case should be failed.")

            case .failure(let error):
                XCTAssertEqual(error, CTError.invalidData)
            }
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    
    private func createJSONMockSession(fromJsonFile file: String, andStatusCode code: Int, andError error: Error?) -> MockURLSession? {
        let data = loadJsonData(file: file)
        
        let response = HTTPURLResponse(url: URL(string: "TestURL")!, statusCode: code, httpVersion: nil, headerFields: nil)
        
        return MockURLSession(completionHandler: (data, response, error))
    }
    
    private func loadJsonData(file: String) -> Data? {
        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
}
