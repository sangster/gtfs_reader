Feature: Configuring the reader

  The user should be able to configure the reader before using it. Although the
  GTFS specification is well definited, it was created with the understanding
  that it would be used by people whose expertise lies in fields other than
  software development. For the same reason, the reader should be able to be
  configured to handle feeds which have unique considerations.

  Scenario: Configuring with a block
    When I want to configure the reader with a block
    Then it should be in the context of a configuration object
     And it should have access to a feed definition

  Scenario: Configuring with a block a second time
    Given the configuration has already been created
    When I want to configure the reader with a block
    Then it should be in the context of the same configuration object

  Scenario: Requesting the current configuration
    Given the configuration has already been created
     When I request the current configuration
     Then it should return the same configuration

  Scenario: Arguments are passed without a block

    Because the given block is executed in the context of the configuration
    object, we allow the caller to pass in arguments to use in their block. It
    doesn't make sense to pass in such arguments without a block to use them.

    When I call config with arguments but no block
    Then I should get an ArgumentError exception

  Scenario: Setting a parameter
    Given there is a configuration with the parameter size
      And the parameter size is set to :some_value
     When I request the parameter size
     Then it should return the value :some_value

  Scenario: Configuring with a block parameter

    Block parameters allow a section of configuration to be configured with a
    user-supplied block. Example:
    GtfsReader.config.feed_definition do
      calendar { id; start_date; end_date }
    end

    The given block is executed in whichever context the feed_definition block
    parameter was configured to supply.

    Given there is a Car class with properties :type, :number_of_wheels, :color
      And there is a car_to_use block parameter that uses the Car class
     When I execute:
       """
       config do
         car_to_use do
           type :coupe
           number_of_wheels 4
           color "orange"
         end
       end
       """
      And I request the parameter car_to_use
     Then the returned object's type should be :coupe
      And the returned object's number_of_wheels should be 4
      And the returned object's color should be 'orange'
