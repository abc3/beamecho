defmodule Bec.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Bec.Repo

  alias Bec.Api.Source

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%Source{}, ...]

  """
  def list_sources do
    Repo.all(Source)
  end

  @doc """
  Gets a single source.

  Raises `Ecto.NoResultsError` if the Source does not exist.

  ## Examples

      iex> get_source!(123)
      %Source{}

      iex> get_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source!(id), do: Repo.get!(Source, id)

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %Source{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs \\ %{}) do
    %Source{}
    |> Source.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a source.

  ## Examples

      iex> update_source(source, %{field: new_value})
      {:ok, %Source{}}

      iex> update_source(source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source(%Source{} = source, attrs) do
    source
    |> Source.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a source.

  ## Examples

      iex> delete_source(source)
      {:ok, %Source{}}

      iex> delete_source(source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source(%Source{} = source) do
    Repo.delete(source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source changes.

  ## Examples

      iex> change_source(source)
      %Ecto.Changeset{data: %Source{}}

  """
  def change_source(%Source{} = source, attrs \\ %{}) do
    Source.changeset(source, attrs)
  end

  alias Bec.Api.App

  @doc """
  Returns the list of app.

  ## Examples

      iex> list_app()
      [%App{}, ...]

  """
  def list_app do
    Repo.all(App)
  end

  @doc """
  Gets a single app.

  Raises `Ecto.NoResultsError` if the App does not exist.

  ## Examples

      iex> get_app!(123)
      %App{}

      iex> get_app!(456)
      ** (Ecto.NoResultsError)

  """
  def get_app!(id), do: Repo.get!(App, id)

  @doc """
  Creates a app.

  ## Examples

      iex> create_app(%{field: value})
      {:ok, %App{}}

      iex> create_app(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_app(attrs \\ %{}) do
    %App{}
    |> App.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a app.

  ## Examples

      iex> update_app(app, %{field: new_value})
      {:ok, %App{}}

      iex> update_app(app, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_app(%App{} = app, attrs) do
    app
    |> App.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a app.

  ## Examples

      iex> delete_app(app)
      {:ok, %App{}}

      iex> delete_app(app)
      {:error, %Ecto.Changeset{}}

  """
  def delete_app(%App{} = app) do
    Repo.delete(app)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking app changes.

  ## Examples

      iex> change_app(app)
      %Ecto.Changeset{data: %App{}}

  """
  def change_app(%App{} = app, attrs \\ %{}) do
    App.changeset(app, attrs)
  end

  alias Bec.Api.Handler

  @doc """
  Returns the list of handlers.

  ## Examples

      iex> list_handlers()
      [%Handler{}, ...]

  """

  # def list_handlers do
  #   Repo.all(Handler)
  #   |> Repo.preload([:sources])

  #   # |> Repo.preload(:apps)
  # end

  def list_handlers do
    Repo.all(
      from(h in Handler,
        # where: h.active == true,
        preload: [:source, :app],
        order_by: [desc: h.inserted_at]
      )
    )
  end

  @doc """
  Gets a single handler.

  Raises `Ecto.NoResultsError` if the Handler does not exist.

  ## Examples

      iex> get_handler!(123)
      %Handler{}

      iex> get_handler!(456)
      ** (Ecto.NoResultsError)

  """
  def get_handler!(id), do: Repo.get!(Handler, id)

  @spec get_handler(id :: binary) :: Handler.t() | nil
  def get_handler(id) do
    Repo.all(
      from(h in Handler,
        where: h.id == ^id,
        preload: [:source, :app]
      )
    )
    |> case do
      [handler] -> handler
      [] -> nil
    end
  end

  @doc """
  Creates a handler.

  ## Examples

      iex> create_handler(%{field: value})
      {:ok, %Handler{}}

      iex> create_handler(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_handler(attrs \\ %{}) do
    %Handler{}
    |> Handler.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a handler.

  ## Examples

      iex> update_handler(handler, %{field: new_value})
      {:ok, %Handler{}}

      iex> update_handler(handler, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_handler(%Handler{} = handler, attrs) do
    handler
    |> Handler.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a handler.

  ## Examples

      iex> delete_handler(handler)
      {:ok, %Handler{}}

      iex> delete_handler(handler)
      {:error, %Ecto.Changeset{}}

  """
  def delete_handler(%Handler{} = handler) do
    Repo.delete(handler)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking handler changes.

  ## Examples

      iex> change_handler(handler)
      %Ecto.Changeset{data: %Handler{}}

  """
  def change_handler(%Handler{} = handler, attrs \\ %{}) do
    Handler.changeset(handler, attrs)
  end

  alias Bec.Api.Job

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """

  def list_jobs do
    Repo.all(Job) |> Repo.preload([:handler])
  end

  def list_waiting_jobs(num \\ 10) do
    Repo.all(
      from(j in Job,
        where: j.status == "waiting",
        order_by: [asc: j.inserted_at],
        limit: ^num
      )
    )
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id)

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
