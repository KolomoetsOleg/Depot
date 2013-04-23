#!/bin/env ruby
# encoding: utf-8
class Product < ActiveRecord::Base
  has_many :line_items
  attr_accessible :description, :image_url, :price, :title
  validates :title, :description,:image_url, presence: true 
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
   with: %r{\.(gif|jpg|png)$}i, message: 'URL must be JPG, PNG or GIF'
  }

  before_destroy :ensure_not_referenced_by_any_line_item


  private

  #убеждаемся в отсутствии товарных позиций, ссылающихся на данный товар
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют товарные позиции')
      return false
    end
  end
end
