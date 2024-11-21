//resets the grid
//heer
module connect4_grid;
   parameter SIZE = 10;
   reg [1:0] grid [0:SIZE-1][0:SIZE-1]; // 2D array (10x10 grid)
   integer i, j;
   integer file; // File handle for writing

   initial begin
      // Read the grid from the file grid.txt
      $readmemh("grid.txt", grid);  // Load the entire grid from the file

      // Display the grid
      $display("Initial grid:");
      display_grid();

      // Update the grid to zeros
      for (i = 0; i < SIZE; i = i + 1) begin
         for (j = 0; j < SIZE; j = j + 1) begin
            grid[i][j] = 0;
         end
      end

      // Write the updated grid back to the file
      file = $fopen("grid.txt", "w"); // Open file for writing
      if (file) begin
         for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
               $fwrite(file, "%h\n", grid[i][j]); // Write grid value as hex
            end
         end
         $fclose(file); // Close the file
         $display("grid.txt updated to all zeros.");
      end else begin
         $display("Error: Could not open grid.txt for writing.");
      end

      // Display the updated grid
      $display("Updated grid:");
      display_grid();
   end

   // Task to display the grid
   task display_grid;
      integer i, j;
      for (i = 0; i < SIZE; i = i + 1) begin
         for (j = 0; j < SIZE; j = j + 1) begin
            $write("%0d ", grid[i][j]);
         end
         $display(""); // Newline after each row
      end
   endtask
endmodule
