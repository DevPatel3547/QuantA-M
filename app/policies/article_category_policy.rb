class ArticleCategoryPolicy < ApplicationPolicy
  def index?
    officer_action_allowed?
  end

  def show?
    officer_action_allowed?
  end

  def delete?
    officer_action_allowed?
  end

  def create?
    officer_action_allowed?
  end

  def update?
    officer_action_allowed?
  end

  def destroy?
    officer_action_allowed?
  end

  private

  def officer_action_allowed?
    user.present? && user.officer?
  end
end
