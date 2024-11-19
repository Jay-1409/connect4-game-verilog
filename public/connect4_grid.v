from flask import Flask, request, jsonify
import subprocess
from flask import render_template
app = Flask(__name__)

#page link : http://127.0.0.1:5000/static/index.html
# Function to run the Verilog simulation and return the updated grid
def run_verilog_simulation(player, column):
    try:
        subprocess.run(["vvp", "connect4.vvp", f"+player={player}", f"+column={column}"], check=True)

        grid = []
        with open("grid.txt", "r") as f:
            for line in f:
                grid.append([int(x) for x in line.split()])

        return grid

    except subprocess.CalledProcessError as e:
        # This will catch any issues with running the Verilog simulation
        raise RuntimeError(f"Verilog simulation failed: {e}")
    
    except FileNotFoundError:
        # This will catch if the output file is not generated or not found
        raise RuntimeError("Output file not found. Make sure the Verilog simulation generates grid_output.txt.")
def check_winner():
    try:
        subprocess.run(["vvp", "win.vvp"], check=True)  # Assuming check_win.vvp will write to win.txt

        with open("win.txt", "r") as f:
            winner = int(f.read().strip())  # Read the winner from win.txt
            return winner
    except FileNotFoundError:
        return 0  # Return 0 if no winner found (file not present)

@app.route('/move', methods=['POST'])
def move():
    try:
        data = request.get_json()
        player = data.get('player')
        column = data.get('column')

        if player is None or column is None:
            return jsonify({"error": "Player or column not provided"}), 400

        # Run the Verilog simulation and get the updated grid
        updated_grid = run_verilog_simulation(player, column)
        
        # After the move, check if there is a winner
        winner = check_winner()

        return jsonify({
            "grid": updated_grid,
            "winner": winner
        })

    except Exception as e:
        # Catch and return any errors
        return jsonify({"error": str(e)}), 500
    
@app.route('/reset', methods=['POST'])
def reset():
    try:
        # Run the Verilog simulation to reset the grid
        subprocess.run(["vvp", "connect4_grid.vvp"], check=True)

        # Verify the grid was reset by reading the file
        grid = []
        with open("grid.txt", "r") as f:
            for line in f:
                grid.append([int(x) for x in line.split()])

        return jsonify({"success": True, "grid": grid})
    except subprocess.CalledProcessError as e:
        return jsonify({"success": False, "error": f"Verilog simulation failed: {e}"})
    except FileNotFoundError:
        return jsonify({"success": False, "error": "grid.txt not found after reset"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

    
@app.route('/check_winner', methods=['GET'])
def check_winner_endpoint():
    try:
        with open("win.txt", "r") as f:
            winner = int(f.read().strip())  # Read the winner from win.txt
            return jsonify({"winner": winner})
    except FileNotFoundError:
        return jsonify({"winner": 0})  # If the file isn't found, assume no winner

@app.route('/')
def home():
    return render_template('index.html')  # No need to specify './static/'


if __name__ == "__main__":
    app.run(debug=True)
