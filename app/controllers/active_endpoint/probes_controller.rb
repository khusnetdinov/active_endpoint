require_dependency 'active_endpoint/application_controller'

module ActiveEndpoint
  class ProbesController < ApplicationController
    def index
      @probes_group = ActiveEndpoint::Probe.group_by_endpoint
    end

    def show
      @probes = ActiveEndpoint::Probe.where(endpoint: params[:id])
    end

    def show_response
      @probe = ActiveEndpoint::Probe.find(params[:probe_id])
    end

    def destroy
      ActiveEndpoint::Probe.find(params[:id]).destroy
      redirect_to :back
    end
  end
end
