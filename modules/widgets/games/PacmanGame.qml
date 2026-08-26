import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.commons
import qs.components
import qs.services

// Self-contained Pacman mini-game.
// Usage: PacmanGame { anchors.fill: parent; onBackRequested: /* switch view back */ }
Item {
    id: game

    signal backRequested

    // ---------- Maze definition ----------
    // '#' wall, '.' dot, ' ' empty passable cell (no dot)
    readonly property var mazeTemplate: ["###############", "#.............#", "#.###.#.#.###.#", "#.............#", "#.###.#.#.###.#", "#.............#", "###.#.###.#.###", "#.............#", "#.###.#.#.###.#", "#.............#", "#.###.#.#.###.#", "#.............#", "###############"]
    readonly property int cols: mazeTemplate[0].length
    readonly property int rows: mazeTemplate.length

    property var mazeData: []      // mutable 2D array of characters (rebuilt on reset)
    property int dotsRemaining: 0

    property int score: 0
    property int lives: 3
    property bool gameActive: false
    property bool gameOver: false
    property bool gameWon: false

    // Directions: 0 = right, 1 = down, 2 = left, 3 = up
    readonly property var dirDx: [1, 0, -1, 0]
    readonly property var dirDy: [0, 1, 0, -1]

    property int playerCol: 1
    property int playerRow: 1
    property int playerDir: 0
    property int playerNextDir: 0

    property var ghosts: [] // each: { col, row, dir, color }

    // ---------- Layout / geometry ----------
    property real cellSize: Math.max(8, Math.floor(Math.min(mazeArea.width / cols, mazeArea.height / rows)))
    readonly property real mazePixelWidth: cellSize * cols
    readonly property real mazePixelHeight: cellSize * rows
    readonly property real mazeOffsetX: (mazeArea.width - mazePixelWidth) / 2
    readonly property real mazeOffsetY: (mazeArea.height - mazePixelHeight) / 2

    function cellChar(row, col) {
        if (row < 0 || row >= rows || col < 0 || col >= cols)
            return '#';
        return mazeData[row][col];
    }

    function isWall(row, col) {
        return cellChar(row, col) === '#';
    }

    // IMPORTANT: mazeData is a QML `var` property holding nested JS arrays.
    // Mutating a nested cell in place (mazeData[r][c] = x) does NOT change the
    // property's reference, so QML never fires mazeDataChanged and the bound
    // delegates (the dots) never re-render, even though the underlying data
    // is technically correct. Always go through this helper, which rebuilds
    // the row (and the top-level array) and reassigns `mazeData` so the
    // change is actually observed by bindings.
    function setCell(row, col, value) {
        var newData = mazeData.slice();
        var newRow = newData[row].slice();
        newRow[col] = value;
        newData[row] = newRow;
        mazeData = newData;
    }

    // Same idea as setCell(): reassign the whole `ghosts` array (new
    // reference) so `game.ghosts[index]` bindings in the delegates
    // re-evaluate. Only the ghost at `index` is replaced.
    function setGhost(index, newRow, newCol, newDir) {
        var updated = ghosts.slice();
        var g = updated[index];
        updated[index] = {
            col: newCol,
            row: newRow,
            dir: newDir,
            color: g.color
        };
        ghosts = updated;
    }

    function buildMaze() {
        var data = [];
        var dots = 0;
        for (var r = 0; r < rows; r++) {
            var rowArr = [];
            var line = mazeTemplate[r];
            for (var c = 0; c < cols; c++) {
                var ch = line[c];
                rowArr.push(ch);
                if (ch === '.')
                    dots++;
            }
            data.push(rowArr);
        }
        // clear the player's starting cell so it doesn't start "on" a dot
        if (data[1][1] === '.') {
            data[1][1] = ' ';
            dots--;
        }
        mazeData = data;
        dotsRemaining = dots;
    }

    function resetPositions() {
        playerCol = 1;
        playerRow = 1;
        playerDir = 0;
        playerNextDir = 0;

        ghosts = [
            {
                col: cols - 2,
                row: 1,
                dir: 2,
                color: theme.normal.red
            },
            {
                col: 1,
                row: rows - 2,
                dir: 0,
                color: theme.normal.magenta
            },
            {
                col: cols - 2,
                row: rows - 2,
                dir: 3,
                color: theme.normal.cyan
            }
        ];
    }

    function startGame() {
        buildMaze();
        resetPositions();
        score = 0;
        lives = 3;
        gameOver = false;
        gameWon = false;
        gameActive = true;
        tickTimer.restart();
        game.forceActiveFocus();
    }

    function pauseAfterHit() {
        gameActive = false;
        resetPositions();
        respawnTimer.restart();
    }

    function endGame(won) {
        gameActive = false;
        gameOver = !won;
        gameWon = won;
        tickTimer.stop();
    }

    // ---------- Game loop ----------
    Timer {
        id: tickTimer
        interval: 190
        repeat: true
        running: false
        onTriggered: game.advance()
    }

    Timer {
        id: respawnTimer
        interval: 190
        repeat: false
        onTriggered: {
            game.gameActive = true;
        }
    }

    // Moves the player, then each ghost one at a time, checking for a hit
    // after every single step (not once at the end). This is what catches
    // the "swap" case: player steps into the ghost's old cell while that
    // same ghost steps into the player's old cell in the same tick. If we
    // only compared final positions after moving everyone, the two would
    // have crossed paths without ever sharing a cell at the same instant,
    // and the hit would be missed.
    function advance() {
        if (!gameActive)
            return;

        var playerPrevRow = playerRow;
        var playerPrevCol = playerCol;

        movePlayer();

        // A ghost may already be sitting on the cell the player just moved into.
        if (checkHit())
            return;

        for (var i = 0; i < ghosts.length; i++) {
            var ghostPrevRow = ghosts[i].row;
            var ghostPrevCol = ghosts[i].col;

            moveGhost(i);

            if (checkHit(i, ghostPrevRow, ghostPrevCol, playerPrevRow, playerPrevCol))
                return;
        }
    }

    function movePlayer() {
        // try queued direction first, fall back to current direction
        var tryDirs = [playerNextDir, playerDir];
        for (var i = 0; i < tryDirs.length; i++) {
            var d = tryDirs[i];
            var nr = playerRow + dirDy[d];
            var nc = playerCol + dirDx[d];
            if (!isWall(nr, nc)) {
                playerDir = d;
                playerRow = nr;
                playerCol = nc;
                break;
            }
        }

        if (mazeData[playerRow][playerCol] === '.') {
            setCell(playerRow, playerCol, ' '); // reassigns mazeData -> dot disappears
            SoundService.playSound("pick");
            dotsRemaining--;
            score += 10;
            if (dotsRemaining <= 0) {
                endGame(true);
            }
        }
    }

    function moveGhost(index) {
        var g = ghosts[index];
        var candidates = [];
        for (var d = 0; d < 4; d++) {
            if (d === (g.dir + 2) % 4)
                // avoid instant reversal when alternatives exist
                continue;
            var nr = g.row + dirDy[d];
            var nc = g.col + dirDx[d];
            if (!isWall(nr, nc))
                candidates.push(d);
        }
        if (candidates.length === 0) {
            // dead end: allow reversal
            var back = (g.dir + 2) % 4;
            if (!isWall(g.row + dirDy[back], g.col + dirDx[back]))
                candidates.push(back);
        }

        var chosen = g.dir;
        if (candidates.length > 0)
            chosen = candidates[Math.floor(Math.random() * candidates.length)];

        var newRow = g.row;
        var newCol = g.col;
        if (!isWall(g.row + dirDy[chosen], g.col + dirDx[chosen])) {
            newRow = g.row + dirDy[chosen];
            newCol = g.col + dirDx[chosen];
        }

        setGhost(index, newRow, newCol, chosen);
    }

    // Two call shapes:
    //  - checkHit()                         -> overlap check only, against every ghost's current cell
    //  - checkHit(i, gPrevRow, gPrevCol,     -> overlap check against ghost i's new cell, PLUS
    //             pPrevRow, pPrevCol)           a swap/pass-through check for that one ghost
    function checkHit(ghostIndex, ghostPrevRow, ghostPrevCol, playerPrevRow, playerPrevCol) {
        if (ghostIndex === undefined) {
            for (var i = 0; i < ghosts.length; i++) {
                if (ghosts[i].row === playerRow && ghosts[i].col === playerCol) {
                    registerHit();
                    return true;
                }
            }
            return false;
        }

        var g = ghosts[ghostIndex];
        var overlap = (g.row === playerRow && g.col === playerCol);
        var swapped = (playerRow === ghostPrevRow && playerCol === ghostPrevCol && g.row === playerPrevRow && g.col === playerPrevCol);

        if (overlap || swapped) {
            registerHit();
            return true;
        }
        return false;
    }

    function registerHit() {
        lives--;
        if (lives <= 0) {
            endGame(false);
        } else {
            pauseAfterHit();
        }
    }

    Component.onCompleted: startGame()

    // ---------- Input ----------
    focus: true
    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_W:
        case Qt.Key_Up:
            playerNextDir = 3;
            event.accepted = true;
            break;
        case Qt.Key_S:
        case Qt.Key_Down:
            playerNextDir = 1;
            event.accepted = true;
            break;
        case Qt.Key_A:
        case Qt.Key_Left:
            playerNextDir = 2;
            event.accepted = true;
            break;
        case Qt.Key_D:
        case Qt.Key_Right:
            playerNextDir = 0;
            event.accepted = true;
            break;
        }
    }

    // ---------- UI ----------
    ColumnLayout {
        anchors.fill: parent
        spacing: ScalerService.s(10)

        RowLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(10)

            ButtonIconText {
                name: "arrow_back"
                onClicked: game.backRequested()
                textColor: theme.normal.red
            }
            CustomText {
                name: "Score: " + game.score
            }

            Item {
                Layout.fillWidth: true
            }
            IconText {
                name: "favorite"
                size: "small"
                textColor: game.lives >= 1 ? theme.normal.red : theme.primary.dim_foreground
            }
            IconText {
                name: "favorite"
                size: "small"
                textColor: game.lives >= 2 ? theme.normal.red : theme.primary.dim_foreground
            }
            IconText {
                name: "favorite"
                size: "small"
                textColor: game.lives >= 3 ? theme.normal.red : theme.primary.dim_foreground
            }
        }

        Item {
            id: mazeArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Walls + dots
            Repeater {
                model: game.rows * game.cols
                delegate: Item {
                    property int r: Math.floor(index / game.cols)
                    property int c: index % game.cols
                    // Binding recomputes whenever game.mazeData changes reference (see setCell)
                    property string ch: game.mazeData.length ? game.mazeData[r][c] : '#'
                    x: game.mazeOffsetX + c * game.cellSize
                    y: game.mazeOffsetY + r * game.cellSize
                    width: game.cellSize
                    height: game.cellSize

                    Rectangle {
                        visible: parent.ch === '#'
                        anchors.fill: parent
                        color: theme.button.background
                    }

                    Rectangle {
                        visible: parent.ch === '.'
                        anchors.centerIn: parent
                        width: ScalerService.s(5)
                        height: ScalerService.s(5)
                        radius: ScalerService.s(5) / 2
                        color: theme.button.text
                    }
                }
            }

            // Player (Pacman)
            Item {
                id: playerItem
                width: game.cellSize
                height: game.cellSize
                x: game.mazeOffsetX + game.playerCol * game.cellSize
                y: game.mazeOffsetY + game.playerRow * game.cellSize
                rotation: game.playerDir === 0 ? 0 : game.playerDir === 1 ? 90 : game.playerDir === 2 ? 180 : 270

                Behavior on x {
                    NumberAnimation {
                        duration: 170
                        easing.type: Easing.Linear
                    }
                }
                Behavior on y {
                    NumberAnimation {
                        duration: 170
                        easing.type: Easing.Linear
                    }
                }

                IconText {
                    anchors.centerIn: parent
                    size: "small"
                    textColor: theme.normal.yellow
                    name: "󰮯"
                    fontFamily: "Symbols Nerd Font"
                }
            }

            // Ghosts
            // NOTE: model is a fixed integer (game.ghosts.length), NOT the
            // ghosts array itself. This keeps each delegate Item alive
            // across ticks instead of being destroyed/recreated whenever
            // moveGhost() reassigns `ghosts` to a new array. A persistent
            // Item is required for `Behavior on x/y` to animate — it only
            // triggers when a property changes on an item that already
            // exists, not on the item's initial creation values.
            Repeater {
                model: game.ghosts.length
                delegate: Item {
                    id: ghostDelegate
                    required property int index
                    readonly property var ghost: game.ghosts[index]

                    width: game.cellSize
                    height: game.cellSize
                    x: game.mazeOffsetX + ghost.col * game.cellSize
                    y: game.mazeOffsetY + ghost.row * game.cellSize

                    Behavior on x {
                        NumberAnimation {
                            duration: 170
                            easing.type: Easing.Linear
                        }
                    }
                    Behavior on y {
                        NumberAnimation {
                            duration: 170
                            easing.type: Easing.Linear
                        }
                    }

                    IconText {
                        anchors.centerIn: parent
                        size: "small"
                        textColor: ghostDelegate.ghost.color
                        name: "󰊠"
                        fontFamily: "Symbols Nerd Font"
                    }
                }
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        visible: game.gameOver || game.gameWon
        color: Qt.rgba(0, 0, 0, 0.6)
        radius: theme ? 0 : 0

        ColumnLayout {
            anchors.centerIn: parent
            spacing: ScalerService.s(14)

            CustomText {
                Layout.alignment: Qt.AlignHCenter
                name: game.gameWon ? "You win!" : "Game Over"
            }
            CustomText {
                Layout.alignment: Qt.AlignHCenter
                name: "Score: " + game.score
            }
            ButtonText {
                Layout.alignment: Qt.AlignHCenter
                name: "Play Again"
                onClicked: game.startGame()
            }
            ButtonText {
                Layout.alignment: Qt.AlignHCenter
                name: "Back to Menu"
                onClicked: game.backRequested()
            }
        }
    }
}
