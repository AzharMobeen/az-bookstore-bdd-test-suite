# Common feature files should be used from other feature files direct will be failed if we are using an other common feature file
@ignore
Feature: Common Add Book

  Background:
    * url baseUrl
    * def StringUtils = Java.type('com.az.bookstore.util.StringUtils')
    * def randomString = new StringUtils();
    * def bookNameRandomString = randomString.getRandomString()
    * def bookISBNRandomString = randomString.getRandomString()

  Scenario: Get Book
    * def addBookResponse = call read('common/bookstore-add-book.feature')
    * print addBookResponse
    * def bookId = addBookResponse.response.bookId
    Given path '/books/'+bookId
    And headers addBookResponse.requestHeaders
    When method get
    Then status 200
    And def getBookResponse = response
    * print 'Get Book response: ', getBookResponse
    * match getBookResponse.bookId == bookId