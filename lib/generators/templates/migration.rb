class CreateActiveEndpointProbes < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :active_endpoint_probes do |t|
      t.string :type, default: '', index: true

      t.string :uuid, null: false, index: true
      t.string :endpoint, null: false, index: true
      t.string :path, null: false, index: true

      t.string :query_string, null: false
      t.string :request_method, null: false
      t.string :ip, null: false
      t.string :url, null: false

      t.boolean :xhr

      t.datetime :started_at, null: false, index: true
      t.datetime :finished_at

      t.float :duration, nill: false, index: true

      t.json :params, default: '{}'

      t.text :response, default: ''
      t.text :body, default: ''

      t.timestamps
    end
  end
end