class UnreadActivity < Activity

  validates_format_of :subject_type, :with => /User/
  validates_presence_of :subject_id

  alias_attr :user, :subject
  alias_attr :unread_count, :extra

  def validate_on_create
    unless unread_count.to_i > 0
      errors.add("unread_count", "must be greater than zero")
    end
  end

  protected

  before_validation_on_create :set_access
  def set_access
    self.access = Activity::PRIVATE
    self.unread_count = user.relationships.sum('unread_count').to_s
  end

  # We want to delete the other UnreadActivities even if we don't pass
  # validations, because if there are no unread messages, we want no
  # UnreadActivities.
  before_validation_on_create :destroy_twins
  def destroy_twins
    UnreadActivity.destroy_all 'subject_id = %s' % user.id
  end

  public

  def description(options={})
    "You have {count} unread [private messages]"[:activity_unread, unread_count].sub(
      /\[(.*)\]/,
      options[:view].link_to('\1', options[:view].send(:conversations_path))
    )
  end

  def created_at
    nil
  end

  def icon
    'page_message'
  end

end