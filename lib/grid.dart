import 'dart:math';

enum Team { blue, green }

const int gridDim = 40;

/// An 40 x 40 grid with 'team' for each cell.
class FieldGrid {
  final List<List<Team>> _teamGrid;
  final List<List<int>> _ageGrid;

  // bool isShuffling = false;

  FieldGrid()
      : _teamGrid =
            List.generate(gridDim, (index) => List.filled(gridDim, Team.blue)),
        _ageGrid = List.generate(gridDim, (index) => List.filled(gridDim, 0)) {
    initializeTeams();
    // randomizeTeams();
  }

  void initializeTeams() {
    for (int r = 0; r < gridDim; r++) {
      for (int c = 0; c < gridDim; c++) {
        if (c < gridDim / 2) {
          _teamGrid[r][c] = Team.green;
        }
      }
    }
  }

  void randomizeTeams() {
    Random rand = Random();
    for (int r = 0; r < gridDim; r++) {
      for (int c = 0; c < gridDim; c++) {
        _teamGrid[r][c] = rand.nextBool() ? Team.green : Team.blue;
      }
    }
  }

  Team teamAt(int col, int row) {
    return _teamGrid[row][col];
  }

  void setTeamAt(int col, int row, Team team) {
    _teamGrid[row][col] = team;
  }

  Team toggleTeamAt(int col, int row) {
    Team team = _teamGrid[row][col];
    if (team == Team.blue) {
      _teamGrid[row][col] = Team.green;
    } else {
      _teamGrid[row][col] = Team.blue;
    }
    return _teamGrid[row][col];
  }

  int ageAt(int col, int row) {
    return _ageGrid[row][col];
  }

  void setAgeAt(int col, int row, int age) {
    _ageGrid[row][col] = age;
  }
}
