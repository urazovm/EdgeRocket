class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.where(skill_id: params["skill_id"]) if params["skill_id"]
    @selected = params["skill_id"].to_i
    @skills = Skill.all
    @products = Product.all
  end

  def create

    @recommendation = Recommendation.create!(skill_id: params[:skill_id], product_id: params[:product_id])
    redirect_to :back

  end

  def destroy
    recommendation = Recommendation.find(params[:id])
    recommendation.destroy
    redirect_to :back
  end

end
