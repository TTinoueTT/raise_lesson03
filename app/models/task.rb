class Task < ApplicationRecord
  has_one_attached :image # １つのタスクに1つの画像を紐づける
  # before_validation :set_nameless_name
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user
  # このクラスは belongs_to で指定したクラスに従属している
  # 従属先のクラスのidを利用したレコードを複数登録可能
  scope :recent, -> { order(created_at: :desc) }

  def self.csv_attributes # CSVデータをどの属性の順番で出力を行うか定義
    %w[name description created_at updated_at]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map { |attr| task.send(attr) }
      end
    end
  end

  # Ex:- scope :active, -> {where(:active => true)}
  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  # def set_nameless_name
  #   self.name = '名前なし' if name.blank?
  # end
end
