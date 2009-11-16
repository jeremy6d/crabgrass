Feature: Destroying groups that don't have a council
  In order to remove an inactive, a hijacked or an old group
  As a member of that group
  I want to destroy that group and I want to not be able to easily destroy groups used by other people.

Background:
  Given a group: "rainbow" exist with name: "Rainbow"
  And a user: "blue" exists with display_name: "Blue"
  And user: "blue" is a member of that group
  And I am logged in as that user
  Given I am on that group's landing page

Scenario: The group has many members, so I can propose to destroy the group
  Given that group has 5 members
  When I follow "Propose to destroy this group"
  And I press "Destroy"
  Then I should be on the group's page
  And I should not see "Propose to destroy this group"
  And i should see "Your proposal to destory this group has been sent to the groups members. If this proposal is not vetoed in a month, this group will be destroyed"
  And I should receive an email with subject: "Blue has proposed to delete group Rainbow!"


Scenario: I propose to destroy a group that has other people in it. That proposal takes effect after 1 month  and the group is destroyed.
  Given that group has 5 members
  When I follow "Propose to destroy this group"
  And I press "Destroy"
  And I wait 1 month
  Then that group should not exist
  And I should receive an email with subject: "Group Rainbow has been deleted by Blue!"
  And I should receive an email body containing a destroyed groups directory link


Scenario: I propose to destroy a group that has other people in it. That proposal can be vetoed within a month.
  Given that group has 5 members
  And the group has been proposed for destruction
  And I am on my group destruction proposals page
  When I follow "reject"
  And I wait 1 month
  And I go to the group page
  Then I should see "Propose to destroy this group"



