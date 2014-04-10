class Ability
  include CanCan::Ability

  def initialize(user)
    visitor = true unless user
    user ||= User.new
    return admin_abilities(user)    if user.admin?
    return user_abilities(user)     unless visitor
    return visitor_abilities(user)
  end

private

  def admin_abilities user
    can :manage, :all
  end

  def user_abilities(user)
    visitor_abilities(user)

    can :update, User do |object|
      user.id == object.id
    end

    can :read, ShoppingCart

    can :create, UserFavorite

    can :create, Build

    can :update, Build do |build|
      build.user_id == user.id
    end

    can :edit, Player do |player|
      user.account_name == player.account
    end

    can :create, Player do
      user.account.present?
    end

    can :update, Player do |player|
      player.account == user.account_name
    end
  end

  def visitor_abilities user
    can :read, Build do |build|
      build.published? || can?(:update, build)
    end
  end
end
