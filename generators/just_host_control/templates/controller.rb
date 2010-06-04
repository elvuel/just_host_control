class <%= class_name %>Controller < ApplicationController
  # cattr_accessor :host_home, :rails_port
  <%= layout %>
  before_filter :is_admin?

  @@host_home = '/home/yours'
  @@rails_port = '12345'
  
  def index
    @form = ""
    @result = '<a href="http://elvuel.com" target="_blank">link_to :Elvuel </a>'
    <%= render %>
  end
  
  def mongrelrails
    if justhost?
      @form = form_for 'mongrelrails', 'operate', "Only: 'start' 'stop' 'restart'"
      @result = ""
      if params[:operate].to_s.empty?
        @result = ' >'
      else
        cmd = "#{system_cmd('which mongrel_rails')} "
        case params[:operate]
        when "start"
          cmd << "start -p #{@@rails_port} -d -e production -P #{RAILS_ROOT}/log/mongrel.pid"
        when "stop"
          cmd << "stop -P #{RAILS_ROOT}/log/mongrel.pid"
        when "restart"
          cmd << "restart -P #{RAILS_ROOT}/log/mongrel.pid"
        else
          cmd = ""
        end
        @result = "#{cmd}<br />#{system_cmd(cmd)}" unless cmd.empty?
      end
    else
      @form = ''
      @result = ' > Just JustHost.'
    end
    <%= render %>
  end
  
  def mongrelrails_pid
    @form = ''
    @result = ' > Does not exist.'
    @result = system_cmd "cat #{RAILS_ROOT}/log/mongrel.pid" if justhost?
    <%= render %>
  end
  
  def run_cmd
    @form = form_for 'run_cmd', 'cmd', "Example: 'ps -axu | more' or 'which ruby'."
    @result = ' > Enter your commands...'
    unless params[:cmd].to_s.empty?
      @result = system_cmd params[:cmd]
    end
    <%= render %>
  end
  
  def run_rails_script
    @form = form_for 'run_rails_script', 'params', "Example: <strike>rails</script> g |<strike>script/</strike>generate scaffold post title:string body:text."
    if params[:params].to_s.empty?
      @result = ' > Example: generate scaffold post title:string body:text'
    else
      cmd = ""
      if justhost?
        if rails3?
          cmd = "export HOME=#{@@host_home} && #{system_cmd('which ruby')} rails #{params[:params]}"
        else
          cmd = "export HOME=#{@@host_home} && #{system_cmd('which ruby')} script/#{params[:params]}"
        end
      else
        if rails3?
          cmd = "#{RAILS_ROOT}/rails #{params[:params]}"
        else
          cmd = "#{RAILS_ROOT}/script/#{params[:params]}"
        end
      end
      @result = cmd + "<br />" + system_cmd(cmd)
    end
    <%= render %>
  end
  
  def task_list
    @form = form_for 'task_rake', 'task', "Example: rake db:migrate. Just input 'db:migrate' and run."
    @result = system_cmd 'rake -T'
    <%= render %>
  end
  
  def task_rake
    @form = form_for 'task_rake', 'task', "Example: <strike>rake</strike> db:migrate. Just input 'db:migrate' and run."
    if params[:task].to_s.empty?
      @result = " >Task can not be blank."
    else
      @result = system_cmd "rake -f #{RAILS_ROOT}/Rakefile #{params[:task]}"
    end
    <%= render %>
  end
  
  private
    def is_admin?
      # redirect_to '/' unless session[:your_admin_session]
      true
    end
    
    def justhost?
      true
    end
  
    def rails3?
      Rails::VERSION::MAJOR >= 3
    end
  
    def system_cmd(cmd)
      `#{cmd}`.chomp.gsub("\n", "<br />")
    end
    
    def form_for(action, text_field, msg)
      "<form action='/<%= file_name %>/#{action}' method='get'><input type='text' class='enter' name='#{text_field}' /><input type='submit' value='Run!'><br /><div id='msg'>(#{msg})</div></form>"
    end

end
