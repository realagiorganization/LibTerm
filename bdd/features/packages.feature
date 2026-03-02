Feature: LibTerm packages repository is available
  As a maintainer
  I want bundled packages to be present in the tree
  So installs and integrations match other shell apps

  Scenario: Packages subtree contains default archives
    Given the packages repository is vendored
    Then the packages list includes required archives
