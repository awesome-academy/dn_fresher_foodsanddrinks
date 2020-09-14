# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    alias_action :create, :read, :update, :destroy, to: :crud

    if user.present?
      if user.admin?
        can :manage, :all
      elsif user.member?
        can %i(update show), User, id: user.id
        can %i(create update show), Order, user_id: user.id
        can :destroy, :session
      end
    else
      can :crud, :cart
      can :create, :registration
      can :create, :session
    end
  end
end
