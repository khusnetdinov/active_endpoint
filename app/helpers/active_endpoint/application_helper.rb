module ActiveEndpoint
  module ApplicationHelper
    SETTINGS = [
      :cache_store_client,
      :cache_prefix,
      :constraint_limit,
      :constraint_period,
      :favicon,
      :logger,
      :log_probe_info,
      :log_debug_info,
      :storage_limit,
      :storage_period,
      :storage_keep_periods,
    ].freeze

    TAGS_COLORS = [
      'label-info',
      'label-success',
      'label-warning',
      'label-danger',
      'label-default'
    ].freeze

    def settings
      SETTINGS
    end

    def tags
      tags = []
      ActiveEndpoint.tags.definition.to_a.each_with_index do |definition, index|
        tags << [definition.first, tag_label_by(index), definition.last, "ActiveEndpoint::Probe.tagged_as(:#{definition.first})"]
      end
      tags
    end

    def label_for(tag)
      TAGS_COLORS[ActiveEndpoint.tags.definition.keys.index(tag.to_sym)]
    end

    def endpoints
      ActiveEndpoint.blacklist.get_endpoints
    end

    def resources
      ActiveEndpoint.blacklist.get_resources
    end

    def actions
      ActiveEndpoint.blacklist.get_actions
    end

    def scopes
      ActiveEndpoint.blacklist.get_scopes
    end

    def endpoints_constraints
      ActiveEndpoint.constraints.get_endpoints.map do |endpoint, constraints|
        constraints_for_html(endpoint, constraints)
      end
    end

    def resources_constraints
      ActiveEndpoint.constraints.get_resources.map do |endpoint, constraints|
        constraints_for_html(endpoint, constraints)
      end
    end

    def actions_constraints
      ActiveEndpoint.constraints.get_actions.map do |endpoint, constraints|
        constraints_for_html(endpoint, constraints)
      end
    end

    def scopes_constraints
      ActiveEndpoint.constraints.get_scopes.map do |endpoint, constraints|
        constraints_for_html(endpoint, constraints)
      end
    end

    private

    def tag_label_by(index)
      if TAGS_COLORS.length > index
        TAGS_COLORS[index]
      else
        TAGS_COLORS.last
      end
    end

    def constraints_for_html(endpoint, constraints)
      rule = constraints[:rule]
      storage = constraints[:storage]
      [endpoint, "#{rule[:limit]} per #{distance_of_time_in_words(rule[:period])}", "#{storage[:limit]} per #{distance_of_time_in_words(storage[:period])}"]
    end
  end
end
