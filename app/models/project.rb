class Project < ActiveRecord::Base
  include Tmt

  validates_presence_of :title
  validates_presence_of :budget
  validates_numericality_of :budget

  validates_presence_of :user_id
  belongs_to :user
  belongs_to :client

  acts_as_noteable

  has_many :expenses, :dependent => :destroy
  accepts_nested_attributes_for :expenses

  has_many :invoices, :dependent => :destroy
  accepts_nested_attributes_for :invoices

  has_many :project_staffs, :dependent => :destroy
  has_many :people, :through => :project_staffs, :uniq => true
  has_many :invitations
  accepts_nested_attributes_for :project_staffs

  has_many :own_hours, :dependent => :destroy
  accepts_nested_attributes_for :own_hours

  has_many :jobs, :order => 'FIELD(jobs.state, "pending", "approved", "paid"), created_at DESC'

  scope :by_title, order(:title)
  scope :in_progress, where('started_on is not NULL and completed_on is NULL')
  scope :completed, where('started_on is not NULL and completed_on is not NULL')
  scope :since,    lambda { |time| where('completed_on >= ?', time) }
  scope :before,   lambda { |time| where('completed_on < ?',  time) }
  scope :by_completed,   lambda { |time| order('completed_on DESC') }
  scope :oldest,  order('started_on ASC')
  scope :newest, order('started_on DESC')
  scope :by_user, lambda {|user_id| where(['user_id = ?', user_id]) }

  before_create :set_cached_budget!
  after_touch :recalculate_cached_budget!
  before_save :update_cached_budget

  def set_cached_budget!
    self.cached_budget = self.budget
  end

  def update_cached_budget
    self.cached_budget = self.budget + project_invoices
  end

  def recalculate_cached_budget!
    self.cached_budget = self.budget + project_invoices
    self.save!
  end

  def project_expenses
    self.expenses.inject(0) {|sum, e| sum += e.amount }
  end

  def project_invoices
    self.invoices.inject(0) {|sum, e| sum += e.cached_invoice_amount }
  end

  def hours_total
    self.jobs.inject(0) {|sum, e| sum += e.hours }
  end

  def employee_hours_total(user)
    self.jobs.by_user(user).inject(0) {|sum, e| sum += e.hours }
  end

  def amount_total
    self.jobs.inject(0) {|sum, e| sum += e.cost }
  end

  def amount_paid
    self.jobs.paid.inject(0) {|sum, e| sum += e.cost }
  end

  def amount_pending
    self.jobs.pending.inject(0) {|sum, e| sum += e.cost }
  end

  def amount_approved
    self.jobs.approved.inject(0) {|sum, e| sum += e.cost }
  end

  def amount_owe
    self.amount_pending + self.amount_approved
  end

  def invoiced
    self.invoices.sum(:cached_invoice_amount)
  end

  def invoiced_hours
    self.invoices.sum(:hours_count)
  end

  def average_invoiced
    self.invoiced / self.invoiced_hours rescue 0
  end

  def any_invoices?
    self.invoices.count > 0
  end

  def completed?
    self.completed_on.present?
  end

  def jobs_by person
    jobs.where(:person_id => person).order('FIELD(jobs.state, "pending", "approved", "paid"), created_at DESC')
  end

  def total_hours_by_person(p)
    self.jobs_by(p).inject(0) {|sum, e| sum += e.hours }
  end

  def total_money_by_person(p)
    self.jobs_by(p).inject(0) {|sum, e| sum += e.cost }
  end

  def project_length
    _end = (self.completed_on || Time.now.to_date)
    _start = (self.started_on || Time.now.to_date)
    _end - _start
  end

  def todays_project?
    self.project_length == 0
  end

  def project_total_hours
    self.project_own_hours + self.hours_total
  end

  def project_own_hours
    self.own_hours.inject(0) {|sum, e| sum += e.hours_count }
  end

  def efficency
    if self.todays_project?
      0
    else
      self.project_total_hours / (self.project_length * 24)
    end
  end

  def personal_rate
    (self.cached_budget - self.project_expenses - self.amount_total) / self.project_own_hours
  end

  def profit
    if self.internal
      self.income
    else
      self.income - self.taxes
    end
  end

  def status
    if profit <= 0
      'red'
    elsif profit <= cached_budget * (self.user.try(:taxes) || 0.3)
      'yellow'
    else
      'green'
    end
  end

  def toggle_turned!
    self.turned_on = !self.turned_on
    self.save
  end

  def year_and_week
    self.completed_on.strftime('%Y-%W')
  end

  def total_invoiced
    self.budget + self.invoiced
  end

  def taxes
    self.income * self.user.my_taxes
  end

  def income
    self.total_invoiced - self.amount_total - self.project_expenses
  end

  def money_chart
    a = [
      {:color => "#1C7B1C", :title => "%%.%% Profit", :value => self.profit },
      {:color => "#FF0000", :title => "%%.%% Employees", :value => self.amount_total },
      {:color => "#004A7F", :title => "%%.%% Expenses", :value => self.project_expenses }
    ].sort{|a, b| a[:value] <=> b[:value]}.reverse
  end

  def time_chart
    [self.project_own_hours, self.hours_total]
  end

  def has_client?
    self.client && self.client.present?
  end

  def project_status
    completed_on ? "completed: #{completed_on}" : 'in progress'
  end

  def start_work!
    update_attribute :work_started_at, Time.now
  end

  def end_work!
    update_attribute :work_started_at, nil
  end

  def hours_working
    ((Time.now- work_started_at) / 3600).round(1) unless work_started_at.nil?
  end

end
