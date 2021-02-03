defmodule MotivusWbApi.RankingTest do
  use MotivusWbApi.DataCase

  alias MotivusWbApi.Ranking

  describe "seasons" do
    alias MotivusWbApi.Ranking.Season

    @valid_attrs %{end_date: "2010-04-17T14:00:00Z", name: "some name", start_date: "2010-04-17T14:00:00Z"}
    @update_attrs %{end_date: "2011-05-18T15:01:01Z", name: "some updated name", start_date: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{end_date: nil, name: nil, start_date: nil}

    def season_fixture(attrs \\ %{}) do
      {:ok, season} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ranking.create_season()

      season
    end

    test "list_seasons/0 returns all seasons" do
      season = season_fixture()
      assert Ranking.list_seasons() == [season]
    end

    test "get_season!/1 returns the season with given id" do
      season = season_fixture()
      assert Ranking.get_season!(season.id) == season
    end

    test "create_season/1 with valid data creates a season" do
      assert {:ok, %Season{} = season} = Ranking.create_season(@valid_attrs)
      assert season.end_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert season.name == "some name"
      assert season.start_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_season/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ranking.create_season(@invalid_attrs)
    end

    test "update_season/2 with valid data updates the season" do
      season = season_fixture()
      assert {:ok, %Season{} = season} = Ranking.update_season(season, @update_attrs)
      assert season.end_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert season.name == "some updated name"
      assert season.start_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_season/2 with invalid data returns error changeset" do
      season = season_fixture()
      assert {:error, %Ecto.Changeset{}} = Ranking.update_season(season, @invalid_attrs)
      assert season == Ranking.get_season!(season.id)
    end

    test "delete_season/1 deletes the season" do
      season = season_fixture()
      assert {:ok, %Season{}} = Ranking.delete_season(season)
      assert_raise Ecto.NoResultsError, fn -> Ranking.get_season!(season.id) end
    end

    test "change_season/1 returns a season changeset" do
      season = season_fixture()
      assert %Ecto.Changeset{} = Ranking.change_season(season)
    end

    test "get_current_season/1 " do
      assert {:ok, %Season{} = season} = Ranking.create_season(%{end_date: "2010-04-24T14:00:00Z", name: "SEASON_TEST", start_date: "2010-04-17T14:00:00Z"})
      date = DateTime.from_naive!(~N[2010-04-20T14:00:00Z], "Etc/UTC")
      season = MotivusWbApi.Stats.get_current_season(date)
      assert season.name == "SEASON_TEST"
    end
  end

  describe "current_season_ranking" do
    alias MotivusWbApi.Ranking.CurrentSeasonRanking

    @valid_attrs %{elapsed_time_ranking: 42, processing_ranking: 42}
    @update_attrs %{elapsed_time_ranking: 43, processing_ranking: 43}
    @invalid_attrs %{elapsed_time_ranking: nil, processing_ranking: nil}

    def current_season_ranking_fixture(attrs \\ %{}) do
      {:ok, current_season_ranking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ranking.create_current_season_ranking()

      current_season_ranking
    end

    test "list_current_season_ranking/0 returns all current_season_ranking" do
      current_season_ranking = current_season_ranking_fixture()
      assert Ranking.list_current_season_ranking() == [current_season_ranking]
    end

    test "get_current_season_ranking!/1 returns the current_season_ranking with given id" do
      current_season_ranking = current_season_ranking_fixture()
      assert Ranking.get_current_season_ranking!(current_season_ranking.id) == current_season_ranking
    end

    test "create_current_season_ranking/1 with valid data creates a current_season_ranking" do
      assert {:ok, %CurrentSeasonRanking{} = current_season_ranking} = Ranking.create_current_season_ranking(@valid_attrs)
      assert current_season_ranking.elapsed_time_ranking == 42
      assert current_season_ranking.processing_ranking == 42
    end

    test "create_current_season_ranking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ranking.create_current_season_ranking(@invalid_attrs)
    end

    test "update_current_season_ranking/2 with valid data updates the current_season_ranking" do
      current_season_ranking = current_season_ranking_fixture()
      assert {:ok, %CurrentSeasonRanking{} = current_season_ranking} = Ranking.update_current_season_ranking(current_season_ranking, @update_attrs)
      assert current_season_ranking.elapsed_time_ranking == 43
      assert current_season_ranking.processing_ranking == 43
    end

    test "update_current_season_ranking/2 with invalid data returns error changeset" do
      current_season_ranking = current_season_ranking_fixture()
      assert {:error, %Ecto.Changeset{}} = Ranking.update_current_season_ranking(current_season_ranking, @invalid_attrs)
      assert current_season_ranking == Ranking.get_current_season_ranking!(current_season_ranking.id)
    end

    test "delete_current_season_ranking/1 deletes the current_season_ranking" do
      current_season_ranking = current_season_ranking_fixture()
      assert {:ok, %CurrentSeasonRanking{}} = Ranking.delete_current_season_ranking(current_season_ranking)
      assert_raise Ecto.NoResultsError, fn -> Ranking.get_current_season_ranking!(current_season_ranking.id) end
    end

    test "change_current_season_ranking/1 returns a current_season_ranking changeset" do
      current_season_ranking = current_season_ranking_fixture()
      assert %Ecto.Changeset{} = Ranking.change_current_season_ranking(current_season_ranking)
    end
  end
end