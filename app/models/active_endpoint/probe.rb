module ActiveEndpoint
  class Probe < ApplicationRecord
    validates :uuid, :started_at, :duration, :endpoint, :ip, :path,
              :request_method, :url, presence: true

    validates :finished_at, presence: true, unless: :skip_validation?

    scope :unregistred, ->() { where(endpoint: :unregistred) }
    scope :registred, ->() { where.not(endpoint: :unregistred) }
    scope :probe, ->(endpoint) { where(endpoint: endpoint) }
    scope :taken_before, ->(period) { where('created_at < ?', period) }

    def tag
      methods = ActiveEndpoint::Extentions::ActiveRecord::METHODS

      ActiveEndpoint.tags.definition.each do |tag_name, operators|
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

    def self.group_by_endpoint
      sql = <<-sql
        select count(*) as amount, endpoint, request_method as method, avg(duration) as duration
        from active_endpoint_probes group by endpoint, request_method
        having endpoint != 'unregistred'
      sql

      results = ActiveRecord::Base.find_by_sql(sql)

      if results.present?
        return results.map(&:deep_symbolize_keys)
      else
        return nil
      end
    end
  end
end
