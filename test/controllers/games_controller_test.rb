require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_game_url
    assert_response :success
  end

  test "should post score" do
    # Step 1: Visit new_game_path to initialize session with grid
    get new_game_url

    # Read the grid assigned by the controller
    grid = session[:grid]

    # Step 2: Post the score using that grid already set in session by the app
    post score_game_url, params: { word: 'test' }

    assert_response :success
    assert_includes @response.body, "Well done! 4 points scored."
    end
end
