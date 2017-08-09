module ActiveEndpoint
  class Probe < ApplicationRecord
    validates :uuid, :started_at, :duration, :endpoint, :ip, :path,
              :request_method, :url, presence: true

    validates :finished_at, presence: true, unless: :skip_validation?

    scope :unregistred, ->() { where(endpoint: :unregistred) }
    scope :registred, ->() { where.not(endpoint: :unregistred) }
    scope :probe, ->(endpoint) { where(endpoint: endpoint) }
    scope :taken_before, ->(period) { where('created_at < ?', period) }
    scope :group_by_endpoint, ->() {
      execute_statement("
        select count(*) as amount, endpoint, request_method as method, avg(duration) as duration
        from active_endpoint_probes group by endpoint, request_method
        having endpoint != 'unregistred'
      ")
    }

    def tag
      definitions = ActiveEndpoint.tags.definition
      methods = ActiveEndpoint::Extentions::ActiveRecord::METHODS

      definitions.each do |tag_name, operators|
        last_operation_index = operators.length - 1

        exec_operator = ''
        operators.each_with_index do |(key, value), index|
          exec_operator << "#{duration * 1000} #{methods[key]} #{value}"
          exec_operator << (index == last_operation_index ? '' : ' && ')
        end

        return tag_name if eval(exec_operator)
      end
    end

    private

    def skip_validation?
      type == 'ActiveEndpoint::UnregistredProbe'
    end

    def self.execute_statement(sql)
      results = ActiveRecord::Base.connection.execute(sql)
      if results.present?
        return results.map(&:deep_symbolize_keys)
      else
        return nil
      end
    end
  end
end
