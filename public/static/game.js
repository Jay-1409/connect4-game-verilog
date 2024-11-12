const SIZE = 10;
let grid = Array(SIZE).fill().map(() => Array(SIZE).fill(0));  // Create an empty grid
let currentPlayer = 1;  // Player 1 starts

// Function to render the grid in HTML
function renderGrid() {
    const gameBoard = document.getElementById('game-board');
    gameBoard.innerHTML = '';  // Clear the board

    for (let j = 0; j < SIZE; j++) {  // Iterate over columns
        for (let i = SIZE - 1; i >= 0; i--) {  // Iterate over rows (bottom to top)
            const cell = document.createElement('div');
            cell.className = 'cell';
            if (grid[i][j] === 1) cell.classList.add('player1');
            if (grid[i][j] === 2) cell.classList.add('player2');

            // Add event listener for column click
            if (grid[i][j] === 0) {  // Only add click event to empty cells
                cell.addEventListener('click', () => handleColumnClick(j)); // Passing column index
            }

            gameBoard.appendChild(cell);
        }
    }
}

// Function to handle column click and make the move
async function handleColumnClick(column) {
    // Find the first empty row in the clicked column
    const row = findEmptyRowInColumn(column);

    if (row === -1) {
        document.getElementById('message').innerText = "Column is full. Choose another column.";
        return;
    }

    // Send move to backend
    const response = await fetch('/move', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ player: currentPlayer, column: column })
    });

    const data = await response.json();

    if (data.error) {
        document.getElementById('message').innerText = data.error;
    } else {
        grid = data.grid;  // Update the grid with the new state
        const winner = await checkWinner();  // Check if there is a winner

        // Update the winner message
        if (winner === 1) {
            document.getElementById('message').innerText = "Player 1 wins!";
        } else if (winner === 2) {
            document.getElementById('message').innerText = "Player 2 wins!";
        } else {
            // No winner yet, so switch players
            currentPlayer = (currentPlayer === 1) ? 2 : 1;
            document.getElementById('message').innerText = `Player ${currentPlayer}'s turn.`;
        }

        renderGrid();  // Re-render the grid
    }
}

// Find the first empty row in the specified column
function findEmptyRowInColumn(column) {
    for (let i = SIZE - 1; i >= 0; i--) {
        if (grid[i][column] === 0) {
            return i;
        }
    }
    return -1;  // Return -1 if the column is full
}

// Reset the game
async function resetGame() {
    const response = await fetch('/reset', {
        method: 'POST',
    });

    const data = await response.json();

    if (data.success) {
        grid = Array(SIZE).fill().map(() => Array(SIZE).fill(0));  // Reset grid in frontend
        currentPlayer = 1;  // Reset the player to Player 1
        renderGrid();  // Re-render the grid
        document.getElementById('message').innerText = "Game has been reset. Player 1's turn.";
    } else {
        document.getElementById('message').innerText = "Failed to reset the game.";
    }
}

// Check for the winner
async function checkWinner() {
    try {
        const response = await fetch('/check_winner', { method: 'GET' });
        const data = await response.json();

        if (data.winner === 1) {
            return 1;  // Player 1 wins
        } else if (data.winner === 2) {
            return 2;  // Player 2 wins
        } else {
            return 0;  // No winner yet
        }
    } catch (error) {
        console.error('Error checking winner:', error);
        return 0;
    }
}

// Initial render of the grid
renderGrid();
    