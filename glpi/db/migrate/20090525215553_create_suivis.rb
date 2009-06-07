class CreateSuivis < ActiveRecord::Migration
  def self.up
    create_table :suivis do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :suivis
  end
end
