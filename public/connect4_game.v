module connect4_game;
    parameter SIZE = 10;
    reg [1:0] grid [0:SIZE-1][0:SIZE-1];  // 2D array for grid, 2 bits per cell (0 = empty, 1 = player 1, 2 = player 2)
    integer row_to_push;   // Row to push a new dot (determined by available space)
    integer player;        // Current player (1 or 2)
    integer column;        // Column where player wants to drop the disc
    integer i, j;
    reg move_done;         // Flag to track if a move is done
    integer outfile;       // File descriptor for writing the updated grid

    // Initial block: where we load the grid and process the move
    initial begin
        // Load the initial grid from a file (e.g., grid.txt)
        $readmemh("grid.txt", grid);  // Read grid from a file (grid.txt should have 10x10 hex data)

        // Display the initial grid
        $display("Initial grid:");
        display_grid();

        // Read the move (player, column) from command-line arguments
        if ($value$plusargs("player=%d", player)) begin
            if ($value$plusargs("column=%d", column)) begin
                $display("Player %d is making a move in column %d.", player, column);

                // Process the move in the chosen column
                row_to_push = -1;  // Initialize the row_to_push to an invalid value
                move_done = 0;     // Reset move_done flag
                for (i = SIZE-1; i >= 0 && !move_done; i = i - 1) begin
                    if (grid[i][column] == 0) begin  // Check if the cell is empty (0 = empty)
                        grid[i][column] = player;  // Place the player's move in the grid
                        row_to_push = i;  // Mark the row where the move was made
                        $display("Player %d places a dot in row %d, column %d", player, row_to_push, column);
                        move_done = 1;  // Set flag to indicate the move is done
                    end
                end

                // Check if the column is full
                if (!move_done) begin
                    $display("Column %d is full. Player %d cannot make a move.", column, player);
                end
            end else begin
                $display("Error: Column argument is missing.");
            end
        end else begin
            $display("Error: Player argument is missing.");
        end

        // Display the updated grid
        $display("\nUpdated grid:");
        display_grid();

        // Write the updated grid to an output file
        outfile = $fopen("grid.txt", "w");
        if (outfile == 0) begin
            $display("Error: Unable to open grid.txt for writing.");
        end else begin
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    $fwrite(outfile, "%0d ", grid[i][j]);
                end
                $fwrite(outfile, "\n");
            end
            $fclose(outfile);
            $display("Updated grid written to grid.txt");
        end
    end

    // Task to display the current state of the grid
    task display_grid;
        begin
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    $write("%0d ", grid[i][j]);
                end
                $display("");  // Newline after each row
            end
        end  
    endtask

endmodule
