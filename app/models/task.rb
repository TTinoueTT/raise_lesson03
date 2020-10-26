class Task < ApplicationRecord
  # before_validation :set_nameless_name
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user
  # このクラスは belongs_to で指定したクラスに従属している
  # 従属先のクラスのidを利用したレコードを複数登録可能

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  # def set_nameless_name
  #   self.name = '名前なし' if name.blank?
  # end
end
