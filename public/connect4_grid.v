module connect4_grid;
   parameter SIZE = 10;
   reg [1:0] grid [0:SIZE-1][0:SIZE-1]; // 2D array (10x10 grid)
   integer i, j;

   initial begin
      // Read the grid from the file grid.txt
      $readmemh("grid.txt", grid);  // Load the entire grid from the file

      // Display the grid
      $display("Initial grid:");
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
