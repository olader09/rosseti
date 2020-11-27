class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :destroy, to: :crd
    alias_action :create, :read, to: :cr

    user ||= User.new

    if user&.class == User
      can :manage, User, id: user.id
      can :cr, Application, user_id: user.id
      can :read, Chat, user_id: user.id
      can :read, Message, sender_id: user.id
    elsif user&.class == Admin
      can :manage, Application
      can :manage, User
      can :manage, Admin
      can :manage, Expert
    elsif user&.class == Expert
      can :manage, Application
      can :read, User
    end
  end
end
