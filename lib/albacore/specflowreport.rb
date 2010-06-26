require 'albacore/albacoremodel'

class SpecFlowReport
  include AlbacoreModel
  include RunCommand
  
  attr_array :projects, :options, :report
  
  def initialize(command='specflow.exe',report='nunitexecutionreport')
  	@command = command
  	@report = report
    @options=[]
    @projects =[]
    super()
  end
  
  def get_command_line
    command_params = []
    command_params << @command
    command_params << get_command_parameters
    commandline = command_params.join(" ")
    @logger.debug "Build SpecFlow Command Line: " + commandline
    commandline
  end
  
  def get_projects
  	if @projects.empty? then
    	failure_message = "SpecFlow Expects at list one project file"
    	@logger.debug failure_message
    	fail_with_message failure_message
    else
    	@projects.map{|asm| "\"#{asm}\""}.join(' ')
    end
  end
  
  def get_options  	
  	if @options.empty? then
      "/xmlTestResult:TestResult.xml /out:specs.html"
    else
      @options.join(" ") 
    end
  end
  	
  def get_command_parameters
    command_params = []
    command_params << @report
    command_params << get_projects
    command_params << get_options
    command_params
  end
  
  def execute()
    command_params = get_command_parameters
    result = run_command "specflow.exe", command_params.join(" ")
    
    failure_message = 'SpecFlow Failed. See Build Log For Detail. ' +  command_params.join(" ")
    fail_with_message failure_message if !result
  end  
end