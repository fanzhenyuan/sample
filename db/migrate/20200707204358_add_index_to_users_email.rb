class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    #与 User 模型的迁移不同,动手编写
    # Rails 中的add_index方法，为 users 表中的 email 列建立索引。索引本身并不能保证唯一 性，所以还要指定unique: true。
    add_index :users, :email, unique: true
  end
end
