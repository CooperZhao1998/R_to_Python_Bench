import subprocess
from pathlib import Path

harness_dir = Path(__file__).resolve().parent
root = harness_dir.parent

python_task = root / "python_task"
ai_outputs = root / "ai_outputs"
ai_outputs.mkdir(exist_ok=True)

print("Running all Python tasks...")

for script in sorted(python_task.glob("*.py")):
    print(f"Executing {script.relative_to(root)} ...")
    subprocess.run(["python", str(script)], check=True)

print("All tasks executed. Outputs are in ai_outputs/")
