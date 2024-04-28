class UserPolicy < ApplicationPolicy
  def index?
    officer_action_allowed?
  end

  def show?
    record == user || officer_action_allowed?
  end

  def show_all?
    record == user
  end

  def delete?
    officer_action_allowed?
  end

  def update?
    record == user or officer_action_allowed?
  end

  def set_officer?
    permitted_emails = %w[prestonb@tamu.edu samueljosemolero@tamu.edu]
    officer_action_allowed? or permitted_emails.include?(user.email)
  end

  def destroy?
    officer_action_allowed?
  end

  private

  def officer_action_allowed?
    user.present? && user.officer?
  end
end
