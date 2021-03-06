class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    # PitchCard auth abilities

    can :see_initiator, PitchCard do |pitch_card|
      pitch_card.identity_scope.is_in_pitch_card_scope(user, pitch_card)
    end

    can :read_pitch, PitchCard do |pitch_card|
      pitch_card.content_scope.is_in_pitch_card_scope(user, pitch_card)
    end

    can :manage, PitchCard do |pitch_card|
      pitch_card.initiator.id == user.id
    end

    # PitchPoint comments auth abilities

    can :see_author, Comment do |comment|
      comment.identity_scope.is_in_comment_scope(user, comment)
    end

    can :read_content, Comment do |comment|
      if comment.has_attribute? (:intiator_content_scope)
        comment.intiator_content_scope.is_in_comment_scope(user, comment)
      else
        comment.content_scope.is_in_comment_scope(user, comment)
      end
    end

    can :manage, Comment do |comment|
      comment.author.id == user.id
    end

    can :see_author, Suggestion do |suggestion|
      suggestion.identity_scope.is_in_comment_scope(user, suggestion)
    end

    can :read_content, Suggestion do |suggestion|
      if suggestion.has_attribute? (:intiator_content_scope)
        suggestion.intiator_content_scope.is_in_comment_scope(user, suggestion)
      else
        suggestion.content_scope.is_in_comment_scope(user, suggestion)
      end
    end

    can :manage, Suggestion do |suggestion|
      suggestion.author.id == user.id
    end

    # override pitch point

    can :initiator_override, Comment do |comment|
      comment.pitch_point.pitch_card.initiator.id == user.id
    end

  end
end
