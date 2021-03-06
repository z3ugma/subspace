require 'fileutils'
require 'erb'
require 'securerandom'
class Subspace::Commands::Init < Subspace::Commands::Base
  def initialize(args, options)
    if args.first == "vars"
      init_vars
    else
      run
    end
  end

  def run
    if File.exists? dest_dir
      answer = ask "Subspace appears to be initialized.  Reply 'yes' to continue anyway: [no] "
      abort unless answer.chomp == "yes"
    end

    FileUtils.mkdir_p File.join dest_dir, "group_vars"
    FileUtils.mkdir_p File.join dest_dir, "host_vars"
    FileUtils.mkdir_p File.join dest_dir, "vars"
    FileUtils.mkdir_p File.join dest_dir, "roles"

    copy ".gitignore"
    #template "../provision.rb"
    template "ansible.cfg"
    template "hosts"
    template "group_vars/all"

    create_vault_pass
    environments.each do |env|
      @env = env
      @hostname = hostname(env)
      template "group_vars/template", "group_vars/#{env}"
      template "host_vars/template", "host_vars/#{env}"
      create_vars_file_for_env env
      template "playbook.yml", "#{env}.yml"
    end
    create_vars_file_for_env "development"
    init_vars

    puts """
    1. Create a server.

    2. Set your server's location:

      vim config/provision/host_vars/production
      vim config/provision/host_vars/dev

    3. Set up your authorized_keys:

      vim config/provision/authorized_keys

    4. Then provision your server:

      subspace provision dev
      subspace provision production

  """

  end

  def init_vars
    FileUtils.mkdir_p File.join dest_dir, "templates"
    copy "templates/application.yml.template"
  end

  private

  def project_name
    File.basename(Dir.pwd)
  end

  def environments
    %w(production dev)
  end

  def hostname(env)
    "#{project_name.gsub('_', '-')}-#{env}"
  end

  def create_vault_pass
    if File.exist? File.join(dest_dir, ".vault_pass")
      say ".vault_pass already exists.  Skipping..."
    else
      File.write File.join(dest_dir, ".vault_pass"), SecureRandom.base64
    end
  end

  def create_vars_file_for_env(env)
    template "vars/template", "vars/#{env}.yml"
    Dir.chdir dest_dir do
      `ansible-vault encrypt vars/#{env}.yml`
    end
  end
end
