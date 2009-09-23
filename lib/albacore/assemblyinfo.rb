class AssemblyInfo
	
	attr_accessor :version, :title, :description, :output_file, :custom_attributes
	attr_accessor :copyright, :com_visible, :com_guid, :company_name, :product_name
	
	def write
		write_assemblyinfo @output_file
	end
	
	def write_assemblyinfo(assemblyinfo_file)
		File.open(assemblyinfo_file, 'w') do |f|			
			f.write using_statements + "\n"
			
			f.write build_attribute("AssemblyTitle", @title) if @title != nil
			f.write build_attribute("AssemblyDescription", @description) if @description != nil
			f.write build_attribute("AssemblyCompany", @company_name) if @company_name != nil
			f.write build_attribute("AssemblyProduct", @product_name) if @product_name != nil
			f.write build_attribute("AssemblyCopyright", @copyright) if @copyright != nil
			
			f.write build_attribute("ComVisible", @com_visible) if @com_visible != nil
			f.write build_attribute("Guid", @com_guid) if @com_guid != nil
			
			f.write build_attribute("AssemblyVersion", @version) if @version != nil
			
			f.write "\n"
			if @custom_attributes != nil
				attributes = build_custom_attributes()
				f.write attributes.join
				f.write("\n")
			end
			
		end
	end
	
	def custom_attributes(attributes)
		@custom_attributes = attributes
	end
	
	def using_statements
		statements = ''
		statements << "using System.Reflection;\n"
		statements << "using System.Runtime.InteropServices;\n"
		statements
	end
	
	def build_attribute(attr_name, attr_data)
		attribute = "[assembly: #{attr_name}("
		attribute << "#{attr_data.inspect}" if attr_data != nil
		attribute << ")]\n"
		attribute
	end
	
	def build_custom_attributes()
		attributes = []
		@custom_attributes.each do |key, value|
			attributes << build_attribute(key, value)
		end
		attributes
	end
	
end