class CreateIncidentEscalations < ActiveRecord::Migration[8.0]
  def change
    create_table :incident_escalations do |t|
      t.references :incident, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :triggered_at
      t.datetime :expires_at

      t.timestamps
    end
    add_index :incident_escalations, :token, unique: true
  end
end
