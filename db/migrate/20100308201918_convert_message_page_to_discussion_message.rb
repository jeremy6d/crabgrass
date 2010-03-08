class ConvertMessagePageToDiscussionMessage < ActiveRecord::Migration
  # MessagePage class has been deleted a while ago,
  # readd it with :: to make it top namespace
  class ::MessagePage < ::Page
  end

  def self.up
    pages = MessagePage.all

    pages.each do |page|
      next unless page.users.count != 2

      sender = page.created_by
      receiver = page.users.detect {|u| u != sender}
      text = page.title

      next if sender.blank? || receiver.blank? || text.blank?

      # create the new message
      sender.send_message_to!(receiver, text)
    end

    MessagePage.destroy_all
  end

  def self.down
  end
end
