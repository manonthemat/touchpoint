class Touch
  include Mongoid::Document
  field :description, type: String
  field :due_date, type: Date
  field :recurrence, type: String
  field :notes, type: String
  field :is_complete, type: Mongoid::Boolean, default: false

  belongs_to :user
  belongs_to :contact

  validates_presence_of :contact
  validates_presence_of :description
  validates_presence_of :due_date
  validates_presence_of :recurrence
  
  #called when a touch is marked as complete, but only if recurrence != "Never".
  #makes a new instance of the touch with the same attribute values as the original
  #touch and increments the date by the appropriate amoutn.
  def make_copy
    new_touch = Touch.new
    new_touch.description = self.description
    new_touch.recurrence = self.recurrence
    new_touch.notes = self.notes
    new_touch.user_id = self.user_id
    new_touch.contact_id = self.contact_id

    case self.recurrence
    when "Every Day"
      if self.due_date < Date.today
        new_touch.due_date = Date.today + 1.day
      elsif self.due_date >= Date.today
        new_touch.due_date = self.due_date + 1.day
      end
    when "Every Week"
      new_touch.due_date = self.due_date + 1.week
    when "Every 2 Weeks"
      new_touch.due_date = self.due_date + 2.weeks
    when "Every Month"
      new_touch.due_date = self.due_date + 1.month
    when "Every Year"
      new_touch.due_date = self.due_date + 1.year
    end

    new_touch.save

  end

end
