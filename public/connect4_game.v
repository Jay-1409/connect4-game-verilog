//modify the grid
//jay
module connect4_game;
    parameter SIZE = 10;
    reg [1:0] grid [0:SIZE-1][0:SIZE-1]; 
    integer row_to_push;   
    integer player;       
    integer column;        
    integer i, j;
    reg move_done;         
    integer outfile;       

    initial begin
        $readmemh("grid.txt", grid);  

        $display("Initial grid:");
        display_grid();

        if ($value$plusargs("player=%d", player)) begin
            if ($value$plusargs("column=%d", column)) begin
                $display("Player %d is making a move in column %d.", player, column);

                row_to_push = -1; 
                move_done = 0;     
                for (i = SIZE-1; i >= 0 && !move_done; i = i - 1) begin
                    if (grid[i][column] == 0) begin  
                        grid[i][column] = player;  
                        row_to_push = i;  
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
