class TradesController < ApplicationController
  include Docs::TradesControllerDocs
  before_action :set_from_user, :set_to_user, :infected_user?, :validate_params, :can_trade?

  api :POST, 'api/trades', 'Create a trade'
  param :from, Hash, required: true, desc: 'From user details' do
    param :id, Integer, required: true, desc: 'ID of the from user'
    param :items, Array, required: true, desc: 'Items to be traded' do
      param :name, String, required: true, desc: 'Name of the item'
      param :quantity, Integer, required: true, desc: 'Quantity of the item'
    end
  end
  param :to, Hash, required: true, desc: 'To user details' do
    param :id, Integer, required: true, desc: 'ID of the to user'
    param :items, Array, required: true, desc: 'Items to be traded' do
      param :name, String, required: true, desc: 'Name of the item'
      param :quantity, Integer, required: true, desc: 'Quantity of the item'
    end
  end
  returns code: 200, desc: 'Trade Successful'
  error code: 404, desc: 'From user not found'
  error code: 404, desc: 'To user not found'
  error code: 422, desc: 'Infected user cannot perform trade'
  error code: 422, desc: 'Validation errors or insufficient items'
  error code: 422, desc: 'Points of items of both users must be equal to trade'
  error code: 500, desc: 'Internal server error'
  create_trade

  def create
    @from.alter_resource(trade_params.dig(:to, :items), trade_params.dig(:from, :items))
    @to.alter_resource(trade_params.dig(:from, :items), trade_params.dig(:to, :items))
    render json: { message: "Trade Successful" }
  end

  private

  def set_from_user
    @from = User.find_by(id: trade_params.dig(:from, :id))
    return if @from.present?
    render json: { message: "From user not found" }, status: :not_found
  end

  def set_to_user
    @to = User.find_by(id: trade_params.dig(:to, :id))
    return if @to.present?
    render json: { message: "To user not found" }, status: :not_found
  end

  def infected_user?
    return unless @from.infected? || @to.infected?
    render json: { message: "Infected user cannot perform trade" }, status: :unprocessable_entity
  end

  def validate_params
    errors = []
    [:from, :to].each do |key|
      trade_items = trade_params.dig(key, :items)
      if trade_items.present?
        user_items = instance_variable_get("@#{key.to_s}").resources.pluck(:name, :quantity).to_h
        trade_items.each do |item|
          if item[:name].in?(user_items.keys)
            errors << "#{key.to_s} user does not contains #{item[:quantity]} units of #{item[:name].pluralize(item[:quantity])} " if item[:quantity].to_f > user_items[item[:name]]
          else
            errors << "#{item[:name]} is not present in user item list for #{key.to_s} user"
          end
        end
      else
        errors << "Trade items must be present for #{key.to_s} user"
      end
    end
    return if errors.blank?
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def can_trade?
    points                 = Zombie::RESOURCES.values.pluck('name', 'points').to_h
    from_points, to_points = [:from, :to].map do |key|
      trade_params.dig(key, :items)&.sum do |item|
        item[:quantity].to_f * points[item[:name]].to_f
      end
    end
    return if from_points == to_points
    render json: { message: "Points of items of both users must be equal to trade" }, status: :unprocessable_entity
  end

  def trade_params
    params.permit(from: [:id, items: [:name, :quantity]], to: [:id, items: [:name, :quantity]])
  end
end
