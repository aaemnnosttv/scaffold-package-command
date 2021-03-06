Feature: Scaffold a README.md file for an existing package

  Scenario: Scaffold a README.md based on the defaults
    Given an empty directory

    When I run `wp scaffold package wp-cli/foo --dir=foo`
    Then STDOUT should contain:
      """
      Success: Created package readme.
      """
    And the foo/README.md file should exist
    And the foo/README.md file should contain:
      """
      Installing this package requires WP-CLI v0.23.0 or greater. Update to the latest stable release with `wp cli update`.
      """
    And the foo/README.md file should contain:
      """
      [![Build Status](https://travis-ci.org/wp-cli/foo.svg?branch=master)
      """

  Scenario: Scaffold a README.md requiring a nightly build
    Given an empty directory

    When I run `wp scaffold package wp-cli/foo --dir=foo --require_wp_cli='~0.24.0-alpha'`
    Then STDOUT should contain:
      """
      Success: Created package readme.
      """
    And the foo/composer.json file should contain:
      """
          "require": {
              "wp-cli/wp-cli": "~0.24.0-alpha"
          },
      """
    And the foo/README.md file should exist
    And the foo/README.md file should contain:
      """
      Installing this package requires WP-CLI v0.24.0-alpha or greater. Update to the latest nightly release with `wp cli update --nightly`.
      """

  Scenario: Scaffold a readme with custom shields
    Given an empty directory
    And a foo/composer.json file:
      """
      {
          "name": "runcommand/profile",
          "description": "Quickly identify what's slow with WordPress.",
          "homepage": "https://runcommand.io/wp/profile/",
          "license": "GPL-2.0",
          "authors": [],
          "minimum-stability": "dev",
          "autoload": {
              "files": [ "command.php" ]
          },
          "require": {
              "wp-cli/wp-cli": "~0.23.0"
          },
          "require-dev": {
              "behat/behat": "~2.5"
          },
          "extras": {
              "readme": {
                  "shields": [
                    "[![CircleCI](https://circleci.com/gh/runcommand/profile/tree/master.svg?style=svg&circle-token=d916e588bf7c8ac469a3bd01930cf9eed886debe)](https://circleci.com/gh/runcommand/profile/tree/master)"
                  ]
              }
          }
      }
      """

    When I run `wp scaffold package-readme foo`
    Then the foo/README.md file should exist
    And the foo/README.md file should contain:
      """
      tree/master.svg?style=svg&circle-token=
      """

  Scenario: Scaffold a readme with a remote support body
    Given an empty directory
    And a foo/composer.json file:
      """
      {
          "name": "runcommand/profile",
          "description": "Quickly identify what's slow with WordPress.",
          "homepage": "https://runcommand.io/wp/profile/",
          "extras": {
              "readme": {
                  "contributing": {
                    "body": "https://gist.githubusercontent.com/danielbachhuber/bb652b1b744cea541705ee9c13605dad/raw/195c17ebb8cf25e947a9df6e02de1e96a084c287/support.md"
                  }
              }
          }
      }
      """

    When I run `wp scaffold package-readme foo`
    Then the foo/README.md file should exist
    And the foo/README.md file should contain:
      """
      ## Contributing

      Support isn't free!
      """

  Scenario: Scaffold a readme with custom sections
    Given an empty directory
    And a foo/composer.json file:
      """
      {
          "name": "runcommand/profile",
          "description": "Quickly identify what's slow with WordPress.",
          "homepage": "https://runcommand.io/wp/profile/",
          "extras": {
              "readme": {
                  "sections": [
                    "Installing",
                    "Donating"
                  ],
                  "donating": {
                    "body": "Give me money!"
                  }
              }
          }
      }
      """

    When I run `wp scaffold package-readme foo`
    Then the foo/README.md file should exist
    And the foo/README.md file should contain:
      """
      Quick links: [Installing](#installing) | [Donating](#donating)
      """
    And the foo/README.md file should contain:
      """
      ## Donating

      Give me money!
      """
