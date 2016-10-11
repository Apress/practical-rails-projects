class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :first_name,                :string
      t.column :last_name,                 :string
      t.column :gender,                    :string
      t.column :birthday,                  :date
      t.column :street,                    :string
      t.column :city,                      :string
      t.column :state,                     :string  
      t.column :zip,                       :string                
    end
  end

  def self.down
    drop_table "users"
  end
end
