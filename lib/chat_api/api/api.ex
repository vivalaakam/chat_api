defmodule ChatApi.API do
  @moduledoc """
  The API context.
  """

  import Ecto.Query, warn: false
  alias Comeonin.Bcrypt
  alias ChatApi.Repo

  alias ChatApi.API.User
  alias ChatApi.API.Chat
  alias ChatApi.API.ChatUser
  alias ChatApi.API.ChatMessage

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_fb_user(fb_id),
      do: Repo.one(
        User
        |> where(fb_id: ^fb_id)
        |> limit(1)
      )

  def get_google_user(google_id),
      do: Repo.one(
        User
        |> where(google_id: ^google_id)
        |> limit(1)
      )

  def get_email_user(email),
      do: Repo.one(
        User
        |> where(email: ^email)
        |> limit(1)
      )

  def check_password(nil, _), do: {:error, "Incorrect username or password"}
  def check_password(user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias ChatApi.API.Chat

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats(user) when user == nil do
    []
  end


  def list_chats(user) do
    query =
      from c in Chat,
           join: u in ChatUser,
           on: c.id == u.chat_id,
           where: u.user_id == ^user.id,
           select: c,
           preload: [
             :users,
             {
               :last_message,
               ^from(
                 c in ChatMessage,
                 order_by: [
                   desc: c.inserted_at
                 ]
               )
             }
           ]

    Repo.all(query)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  def get_chat_with_users!(id) do
    Chat
    |> preload(:users)
    |> Repo.get!(id)
  end


  def get_chat_by_hash!(hash) do
    Repo.one(
      Chat
      |> where(hash: ^hash)
      |> limit(1)
    )
  end

  def get_chat_with_messages!(id) do
    messages = fn chat_ids ->
      ChatMessage
      |> where([c], c.chat_id in ^chat_ids)
      |> order_by(desc: :inserted_at)
      |> limit(25)
      |> Repo.all()
    end

    Chat
    |> preload(messages: ^messages)
    |> preload(:users)
    |> Repo.get!(id)

  end

  def get_chat_messages(chat_id, last_message) when last_message == nil do
    ChatMessage
    |> where(chat_id: ^chat_id)
    |> order_by(desc: :inserted_at)
    |> limit(25)
    |> Repo.all()
  end

  def get_chat_messages(chat_id, last_message) do
    ChatMessage
    |> where([c], c.chat_id == ^chat_id and c.inserted_at < ^last_message)
    |> order_by(desc: :inserted_at)
    |> limit(25)
    |> Repo.all()
  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  def create_message(attrs \\ %{}) do
    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{source: %Chat{}}

  """
  def change_chat(%Chat{} = chat) do
    Chat.changeset(chat, %{})
  end

  alias ChatApi.API.UserSubscription

  @doc """
  Returns the list of user_subscription.

  ## Examples

      iex> list_user_subscription(user)
      [%UserSubscriptions{}, ...]

  """
  def list_user_subscriptions(%User{} = user) do
    UserSubscription
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single user_subscriptions.

  Raises `Ecto.NoResultsError` if the User subscriptions does not exist.

  ## Examples

      iex> get_user_subscriptions!(123)
      %UserSubscriptions{}

      iex> get_user_subscriptions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_subscription!(id), do: Repo.get!(UserSubscription, id)

  @doc """
  Creates a user_subscriptions.

  ## Examples

      iex> create_user_subscriptions(%{field: value})
      {:ok, %UserSubscriptions{}}

      iex> create_user_subscriptions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_subscription(attrs \\ %{}) do
    %UserSubscription{}
    |> UserSubscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_subscriptions.

  ## Examples

      iex> update_user_subscriptions(user_subscriptions, %{field: new_value})
      {:ok, %UserSubscriptions{}}

      iex> update_user_subscriptions(user_subscriptions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_subscription(%UserSubscription{} = user_subscription, attrs) do
    user_subscription
    |> UserSubscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserSubscriptions.

  ## Examples

      iex> delete_user_subscriptions(user_subscriptions)
      {:ok, %UserSubscriptions{}}

      iex> delete_user_subscriptions(user_subscriptions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_subscription(%UserSubscription{} = user_subscription) do
    Repo.delete(user_subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_subscriptions changes.

  ## Examples

      iex> change_user_subscriptions(user_subscriptions)
      %Ecto.Changeset{source: %UserSubscriptions{}}

  """
  def change_user_subscription(%UserSubscription{} = user_subscription) do
    UserSubscription.changeset(user_subscription, %{})
  end
end
