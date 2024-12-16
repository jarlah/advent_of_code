defmodule CommonTest do
  use ExUnit.Case

  test "test map" do
    test_map = [
      # Walls
      %Tile{id: :wall1, x: 0, y: 0, width: 30, height: 1, type: :obstacle, display: "#"},
      %Tile{id: :wall2, x: 0, y: 1, width: 1, height: 8, type: :obstacle, display: "#"},
      %Tile{id: :wall3, x: 29, y: 1, width: 1, height: 8, type: :obstacle, display: "#"},
      %Tile{id: :wall4, x: 0, y: 9, width: 30, height: 1, type: :obstacle, display: "#"},

      # Boxes
      %Tile{id: :box1, x: 5, y: 3, width: 2, height: 2, type: :box, display: "O"},
      %Tile{id: :box2, x: 15, y: 5, width: 2, height: 2, type: :box, display: "O"},
      %Tile{id: :box3, x: 22, y: 2, width: 2, height: 2, type: :box, display: "O"},

      # Player
      %Tile{id: :player, x: 10, y: 4, width: 1, height: 1, type: :robot, display: "P"},

      # Obstacles
      %Tile{id: :obstacle1, x: 8, y: 7, width: 3, height: 1, type: :obstacle, display: "X"},
      %Tile{id: :obstacle2, x: 20, y: 6, width: 1, height: 2, type: :obstacle, display: "Y"},
    ]

    Tile.print_tile_map(test_map)
  end
end
