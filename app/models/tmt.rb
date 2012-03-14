module Tmt

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
  
  module ClassMethods
    
    def acts_as_noteable
      has_many :notes, :as => :noteable, :dependent => :destroy
      accepts_nested_attributes_for :notes, :reject_if => proc { |attrs| attrs[:note].blank? }
    end
    
  end
  
  module InstanceMethods
  end
  
end  
  