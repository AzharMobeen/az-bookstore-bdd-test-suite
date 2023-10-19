Feature: Book Store APIs scenarios

  Background:
    * url baseUrl
    * def StringUtils = Java.type('com.az.bookstore.util.StringUtils')
    * def RandomString = new StringUtils();
    * def bookNameRandomString = RandomString.getRandomString()
    * def bookISBNRandomString = RandomString.getRandomString()
    * def requestHeaders = {API_ACCESS_KEY: '$2a$12$W/lAX/yFLzh7DDxGIPm9vup4E.uB0h1l.B1aJjQzwwkdoM/FTO2vK'}

  @POST-API
  Scenario: Add Book success scenario
    * def addBookRequest = {"bookDTO":{"name":"#(bookNameRandomString)", "description":"Knowledge","price":100,"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBNRandomString)"}}
    Given path '/books'
    And headers requestHeaders
    And request addBookRequest
    When method post
    Then status 200
    And def addBookResponse = response
    * print 'Add Book response: ', addBookResponse

  @POST-API
  Scenario: Add Book negative scenario (without access-key) Bad Request
    * def addBookRequest = {"bookDTO":{"name":"#(bookNameRandomString)", "description":"Knowledge","price":100,"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBNRandomString)"}}
    Given path '/books'
    And request addBookRequest
    When method post
    Then status 400
    * json addBookResponse = response
    * print 'Add Book response: ', addBookResponse
    * match addBookResponse.error == "Bad Request"
    * match addBookResponse.status == 400

  @POST-API
  Scenario: Add Book negative scenario (without request body) Bad Request
    Given path '/books'
    And headers requestHeaders
    When method post
    Then status 400
    * json addBookResponse = response
    * print 'Add Book response: ', addBookResponse
    * match addBookResponse.message == "Invalid request"

  @POST-API
  Scenario: Add Book negative scenario (with already exist book name) Bad Request
    * def getBookResponse = call read('common/bookstore-get-book.feature')
    * print 'Get Book response: ', getBookResponse.response
    * def bookName = getBookResponse.response.name
    * def addBookRequest = {"bookDTO":{"name":"#(bookName)", "description":"Knowledge","price":100,"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBNRandomString)"}}
    Given path '/books'
    And headers requestHeaders
    And request addBookRequest
    When method post
    Then status 409
    And def addBookResponse = response
    * print 'Add Book response: ', addBookResponse
    * match addBookResponse.message == "Book name already exist"

  @POST-API
  Scenario: Add Book negative scenario (with already exist book ISBN) Bad Request
    * def getBookResponse = call read('common/bookstore-get-book.feature')
    * print 'Get Book response: ', getBookResponse.response
    * def bookISBN = getBookResponse.response.isbn
    * def addBookRequest = {"bookDTO":{"name":"#(bookNameRandomString)", "description":"Knowledge","price":100,"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBN)"}}
    Given path '/books'
    And headers requestHeaders
    And request addBookRequest
    When method post
    Then status 409
    And def addBookResponse = response
    * print 'Add Book response: ', addBookResponse
    * match addBookResponse.message == "Book ISBN already exist"

  @Get-API
  Scenario: Get Book by ID
    * def getBookResponse = call read('common/bookstore-get-book.feature')
    * print 'Get Book response: ', getBookResponse.response
    * match getBookResponse.response.name == '#notnull'

  @Put-API
  Scenario: Update Book Price
    * def getBookResponse = call read('common/bookstore-get-book.feature')
    * print 'Get Book response: ', getBookResponse.response
    * def bookId = getBookResponse.response.bookId
    * def bookName = getBookResponse.response.name
    * def bookISBN = getBookResponse.response.isbn
    * def newPrice = 200
    * def updateBookRequest = {"bookId":'#(bookId)', "bookDTO":{"name":"#(bookName)", "description":"Knowledge","price":'#(newPrice)',"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBN)"}}
    Given path '/books'
    And headers requestHeaders
    And request updateBookRequest
    When method put
    Then status 200
    And def updateBookResponse = response
    * print 'Update Book response: ', updateBookResponse
    * match updateBookResponse.response == 'Success'

  @Delete-API
  Scenario: Delete Book
    * def getBookResponse = call read('common/bookstore-get-book.feature')
    * print 'Get Book response: ', getBookResponse.response
    * def bookId = getBookResponse.response.bookId
    Given path '/books/'+bookId
    And headers requestHeaders
    When method delete
    Then status 200
    * json deleteBookResponse = response
    * print 'Delete book response :', deleteBookResponse
    * match deleteBookResponse == true