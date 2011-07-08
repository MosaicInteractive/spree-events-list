class Event < ActiveRecord::Base
  has_attached_file :image, 
                    :styles => { :large => "800x800>",
                                 :medium => "400x400>",
                                 :thumb => "100x100>" }
	before_validation :published

  validates_presence_of :begin_event, :end_event

	scope :publish, {:conditions => [ 'published_at < ? and is_active = ?', Time.zone.now, 1]}

  # visible events that start within 'to' days of today, or ended less than 'from' days ago.
  def Event.find_visible_by_date(to, from) 
    Event.find_all_by_is_active(true, :conditions => ["begin_event > ? or end_event > ?", DateTime.now + to.to_i.days, DateTime.now - from.to_i.days])
  end

	def published
    #self.published_at ||= Time.now unless self.is_active == 0
    if self.is_active == 0
      if !self.published_at.blank?
        self.published_at = nil
      end
    else
      if self.published_at.blank?
        self.published_at = Time.now
      end
    end
  end
end
