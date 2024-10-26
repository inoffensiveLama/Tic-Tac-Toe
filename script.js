const board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
let currentPlayer = 'X';
const boardElement = document.getElementById('board');
const messageElement = document.getElementById('message');
const restartButton = document.getElementById('restartButton');

//Function to print board
function printBoard() {
    boardElement.innerHTML = '';
    board.forEach((cell, index) => {
        const cellElement = document.createElement('div');
        cellElement.classList.add('cell');
        cellElement.innerText = cell;
        cellElement.onclick = () => makeMove(index);
        boardElement.appendChild(cellElement);
    });
}

//This checks if there is a winner.
function checkWinner() {
    const winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical
        [0, 4, 8], [2, 4, 6]             // diagonal
    ];

    for (const combination of winningCombinations) {
        const [a, b, c] = combination;
        if (board[a] === board[b] && board[b] === board[c] && board[a] !== ' ') {
            return board[a];
        }
    }
    return board.includes(' ') ? null : 'Tie';
}

//this first checks if the chosen position is empty. If so it will put in the symbol of the current player
function makeMove(position) {
    if (board[position] === ' ') {
        board[position] = currentPlayer;
        const winner = checkWinner();
        printBoard();
        if (winner) {
            if (winner === 'Tie') {
                messageElement.innerText = "It's a tie!";
            } else {
                messageElement.innerText = `Player ${winner} wins!`;
            }
            boardElement.style.pointerEvents = 'none'; // Disable further moves
        } else {
            currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
        }
    } else {
        messageElement.innerText = 'Invalid move! Try again.';
    }
}

//this resets all fields of the game
function restartGame() {
    for (let i = 0; i < board.length; i++) {
        board[i] = ' ';
    }
    currentPlayer = 'X';
    messageElement.innerText = '';
    printBoard();
    boardElement.style.pointerEvents = 'auto'; // Enable moves again
}

restartButton.onclick = restartGame;

// Initialize the game
printBoard();