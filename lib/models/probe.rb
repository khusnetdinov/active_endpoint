module ActiveEndpoint
  class Probe < ActiveRecord::Base
    def self.table_name_prefix
      'active_enpoint_'
    end

    validates :uuid, :started_at, :duration, :endpoint, :ip, :path,
              :request_method, :url, presence: true

    validates :finished_at, presence: true, unless: :skip_validation?

    scope :unregistred, ->() { where(endpoint: :unregistred) }
    scope :registred, ->() { where.not(endpoint: :unregistred) }
    scope :probe, ->(endpoint) { where(endpoint: endpoint) }
    scope :taken_before, ->(period) { where('created_at < ?', period) }

    private

    def skip_validation?
      type == 'ActiveEndpoint::UnregistredProbe'
    end
  end
end