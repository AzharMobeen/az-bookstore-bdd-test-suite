Feature: Actuator api

  @Get-API
  Scenario: actuator resource is available
    Given url baseUrl + '/actuator'
    When method get
    Then status 200

  @Get-API
  Scenario: health resource status is "up"
    Given url baseUrl + '/actuator/health'
    When method get
    Then status 200
    And match response == {'status':'UP'}