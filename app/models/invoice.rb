class Invoice < ActiveRecord::Base
  belongs_to :project, :touch => true
  validates_presence_of :hours_count
  validates_presence_of :hourly_rate
  validates_presence_of :description
  
  scope :forward,  order('invoices.created_at ASC')
  scope :backward, order('invoices.created_at DESC')
  
  before_save :re_cached_invoice_amount
  
  def re_cached_invoice_amount
    self.cached_invoice_amount = self.hourly_rate * self.hours_count
  end

end
