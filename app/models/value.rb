# == Schema Information
#
# Table name: values
#
#  id         :integer          not null, primary key
#  val_float  :float
#  val_int    :integer
#  val_str    :text
#  val_bool   :boolean
#  sensor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  val_type   :integer
#  time       :integer
#
# Indexes
#
#  index_values_on_sensor_id  (sensor_id)
#

class Value < ActiveRecord::Base
  LIMIT = 4000
  AMOUNT_TO_REMOVE = 1000

  belongs_to :sensor

  validates_presence_of :time, :sensor

  after_create :remove_outdated_values

  def get_value
    case self.sensor.val_type
      when 'float'
        self.val_float
      when 'integer'
        self.val_int
      when 'string'
        self.val_str
      when 'boolean'
        self.val_bool
      else
        raise Exception, "This type is not supported"
    end

  end

  def remove_outdated_values
    if Value.all.size > LIMIT
      Value.order(created_at: :asc).limit(AMOUNT_TO_REMOVE).destroy_all
    end
  end

  def formatted_time
    Time.at(time).strftime("%F %T")
  end
end
