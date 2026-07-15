//
//  GitHub_UsersTests.swift
//  GitHub UsersTests
//
//  Created by Yasser Ghannam on 15.07.26.
//

import XCTest
import RxSwift
import RxCocoa
@testable import GitHub_Users

final class UserSearchViewModelTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testGetUsersWithSuccessfulResponsePublishesUsers() {
        let user = UserModel()
        user.login = "octocat"
        user.id = 1
        
        let service = MockGitHubUsersService()
        service.searchUsersResult = .success(SearchResultsModel(total_count: 1, users: [user]))
        let viewModel = UserSearchViewModel(service: service)
        
        let expectation = expectation(description: "Users are published")
        var receivedUsers: [UserModel] = []
        
        viewModel.users
            .skip(1)
            .drive(onNext: { users in
                receivedUsers = users
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.getUsers(name: "octocat")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedUsers.first?.login, "octocat")
        XCTAssertEqual(service.receivedSearchName, "octocat")
        XCTAssertEqual(service.receivedPageNumber, "1")
    }
    
    func testGetUsersWithEmptySearchDoesNotCallService() {
        let service = MockGitHubUsersService()
        let viewModel = UserSearchViewModel(service: service)
        
        viewModel.getUsers(name: "   ")
        
        XCTAssertNil(service.receivedSearchName)
        XCTAssertNil(service.receivedPageNumber)
    }
}

private final class MockGitHubUsersService: GitHubUsersServicing {
    
    enum MockError: Error {
        case missingStub
    }
    
    var searchUsersResult: Result<SearchResultsModel, Error> = .failure(MockError.missingStub)
    private(set) var receivedSearchName: String?
    private(set) var receivedPageNumber: String?
    
    func searchUsers(name: String, pageNumber: String) -> Single<SearchResultsModel> {
        receivedSearchName = name
        receivedPageNumber = pageNumber
        
        switch searchUsersResult {
        case .success(let result):
            return .just(result)
        case .failure(let error):
            return .error(error)
        }
    }
    
    func userProfile(name: String) -> Single<UserProfileModel> {
        return .error(MockError.missingStub)
    }
    
    func followers(name: String, pageNumber: String) -> Single<[UserModel]> {
        return .error(MockError.missingStub)
    }

    func following(name: String, pageNumber: String) -> Single<[UserModel]> {
        return .error(MockError.missingStub)
    }
}
