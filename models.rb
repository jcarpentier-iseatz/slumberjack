class Slog < ActiveRecord::Base
  default_scope :order => 'id DESC'
  has_many :supplier_slogs
end

class SupplierSlog < ActiveRecord::Base
  default_scope :order => 'id DESC'
  belongs_to :slog
end