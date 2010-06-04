class JustHostControlGenerator < Rails::Generator::NamedBase
  attr_accessor :render, :layout
  
  def manifest 
    record do |m|
      m.class_collisions "#{class_name}Controller",class_name
      
      if actions[0].to_s == "noviews"
        @layout = ''
        @render = "render :template => 'layouts/#{file_name}'"
      else
        @layout = "layout '#{file_name}'"
        @render = ''
        
        m.directory File.join('app/views', class_path, file_name)
        
        %w(index mongrelrails mongrelrails_pid run_cmd run_rails_script task_list task_rake).each do |action|
          m.file 'empty.html.erb', File.join('app/views', class_path, file_name,  "#{action}.html.erb")
          
        end
      end
      m.file 'layout.html.erb', File.join('app/views/layouts', "#{file_name}.html.erb")
      m.template 'controller.rb', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
      
    end
  end
end