# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post, public: true

    return unless user.present?  
    can :read, Post, user: user

    return unless user.admin?  
    can :read, Post
  end
end

