defmodule ChatApiWeb.UserSubscriptionView do
  use ChatApiWeb, :view
  alias ChatApiWeb.UserSubscriptionView

  def render("index.json", %{user_subscriptions: user_subscriptions}) do
    %{data: render_many(user_subscriptions, UserSubscriptionView, "user_subscription.json")}
  end

  def render("show.json", %{user_subscription: user_subscription}) do
    %{data: render_one(user_subscription, UserSubscriptionView, "user_subscription.json")}
  end

  def render("user_subscription.json", %{user_subscription: user_subscription}) do
    %{id: user_subscription.id,
      source: user_subscription.source,
      subscription: user_subscription.subscription}
  end
end
