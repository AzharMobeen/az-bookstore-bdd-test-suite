@ignore
Feature: Common Add Book

  Background:
    * url baseUrl
    * def StringUtils = Java.type('com.az.bookstore.util.StringUtils')
    * def randomString = new StringUtils();
    * def bookNameRandomString = randomString.getRandomString()
    * def bookISBNRandomString = randomString.getRandomString()

  Scenario: Add Book
    * def requestHeaders = {API_ACCESS_KEY: '$2a$12$W/lAX/yFLzh7DDxGIPm9vup4E.uB0h1l.B1aJjQzwwkdoM/FTO2vK'}
    * def addBookRequest = {"bookDTO":{"name":"#(bookNameRandomString)", "description":"Knowledge","price":100,"author":"Mr. Tipu Sultan","type":"CRIME","isbn":"#(bookISBNRandomString)"}}
    Given path '/books'
    And headers requestHeaders
    And request addBookRequest
    When method post
    Then status 200
    And def addBookResponse = response
    * print 'Add Book response: ', addBookResponse