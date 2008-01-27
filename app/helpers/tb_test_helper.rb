module TbTestHelper
	def options_for_association_conditions(association)
		print "!! #{association.name}\n"
		if association.name == :user
		  "active='t'"
		else
		  super
		end
	end
end
