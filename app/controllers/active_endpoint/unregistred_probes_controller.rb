require_dependency 'active_endpoint/application_controller'

module ActiveEndpoint
  class UnregistredProbesController < ApplicationController
    def index
      @probes = ActiveEndpoint::UnregistredProbe.all.select(:id, :uuid, :started_at, :path, :query_string)
    end

    def destroy
      ActiveEndpoint::UnregistredProbe.find(params[:id]).destroy
      redirect_to action: :index
    end
  end
end
