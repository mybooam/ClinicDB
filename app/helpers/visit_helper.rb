module VisitHelper
	def options_for_association_conditions(association)
    if association.name == :users
      "active='t'"
    else
      super
    end
  end
end
