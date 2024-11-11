module check_win;

    // Grid size (10x10)
    parameter SIZE = 10;
    reg [1:0] grid [0:SIZE-1][0:SIZE-1];  // 2D array for grid, 2 bits per cell (0 = empty, 1 = player 1, 2 = player 2)
    integer i, j;
    integer win_file;      // File descriptor for writing the win result
    integer winner;        // 0 = no winner, 1 = player 1 wins, 2 = player 2 wins

    // Initial block to load grid and check for a winner
    initial begin
        // Load the current grid from grid.txt (in hexadecimal format)
        $readmemh("grid.txt", grid);  

        // Set the winner to 0 initially (no winner)
        winner = 0;

        // Check horizontal wins
        for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE-3; j = j + 1) begin
                if (grid[i][j] != 0 && grid[i][j] == grid[i][j+1] && grid[i][j] == grid[i][j+2] && grid[i][j] == grid[i][j+3]) begin
                    winner = grid[i][j];
                end
            end
        end

        // Check vertical wins
        for (i = 0; i < SIZE-3; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
                if (grid[i][j] != 0 && grid[i][j] == grid[i+1][j] && grid[i][j] == grid[i+2][j] && grid[i][j] == grid[i+3][j]) begin
                    winner = grid[i][j];
                end
            end
        end

        // Check diagonal (down-right) wins
        for (i = 0; i < SIZE-3; i = i + 1) begin
            for (j = 0; j < SIZE-3; j = j + 1) begin
                if (grid[i][j] != 0 && grid[i][j] == grid[i+1][j+1] && grid[i][j] == grid[i+2][j+2] && grid[i][j] == grid[i+3][j+3]) begin
                    winner = grid[i][j];
                end
            end
        end

        // Check diagonal (down-left) wins
        for (i = 3; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE-3; j = j + 1) begin
                if (grid[i][j] != 0 && grid[i][j] == grid[i-1][j+1] && grid[i][j] == grid[i-2][j+2] && grid[i][j] == grid[i-3][j+3]) begin
                    winner = grid[i][j];
                end
            end
        end

        // Write the result to win.txt
        win_file = $fopen("win.txt", "w");  // Open win.txt for writing
        if (win_file != 0) begin
            $fwrite(win_file, "%0d", winner);  // Write the winner (1 = player 1, 2 = player 2, 0 = no winner)
            $fclose(win_file);  // Close the file
        end else begin
            $display("Error: Unable to open win.txt for writing.");
        end

        // Output the winner to the console for debugging
        $display("Winner: %0d", winner);
    end
endmodule
