class RakeistranoTask
  attr_reader :name, :role, :primary

  def initialize(options = {})
    @name = options.fetch('task')
    @role = options.fetch('role', :all).to_sym
    @primary = options.fetch('primary', false)
  end

  def description
    ["rake task: rake #{name},", "role: #{role},", "primary: #{primary}"].compact.join(' ')
  end

  def primary?
    primary
  end
end

rake_tasks = YAML.load_file('config/rakeistrano.yml')['rake_tasks'].collect { |t| RakeistranoTask.new(t) }

rake_tasks.each do |rake_task|
  desc rake_task.description
  task rake_task.name do
    role_info = rake_task.primary? ? primary(rake_task.role) : roles(rake_task.role)
    on role_info do
      within release_path do
        with :rails_env => fetch(:rails_env) do
          execute :rake, rake_task.name
        end
      end
    end
  end
end
