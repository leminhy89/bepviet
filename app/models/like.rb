class Like < ActiveRecord::Base
    belongs_to :chef
    belongs_to :recipe
    
    #chi cho phep like 1 lan tren 1 recipe
    validates_uniqueness_of :chef, scope: :recipe
end