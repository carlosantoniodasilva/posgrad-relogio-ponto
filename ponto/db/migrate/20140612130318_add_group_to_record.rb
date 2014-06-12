class AddGroupToRecord < ActiveRecord::Migration
  def change
    add_reference :records, :group, index: true, null: false
    add_foreign_key :records, :record_groups, column: :group_id, dependent: :delete
  end
end
