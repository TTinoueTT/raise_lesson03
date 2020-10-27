class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true

  has_many :tasks
  # このクラスのidを外部キーとして渡し、manyで渡された側で外部キーが複数登録可能
  # 1 : 多 の実現
end
