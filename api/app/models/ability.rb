class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :destroy, to: :crd
    alias_action :create, :read, to: :cr


    user ||= User.new

    if user&.class == User
      can :manage, User, id: user.id
      can :cr, Application
      can :read, Chat
      can :read, Message
    elsif user&.class == Admin
      can :manage, Application
      can :manage, User
      can :manage, Admin
      can :manage, Message
      can :manage, Chat
    end
  end
end
