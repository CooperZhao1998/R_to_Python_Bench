import subprocess
import sys
from pathlib import Path

harness_dir = Path(__file__).resolve().parent
root = harness_dir.parent

python_task = root / "python_task"
ai_outputs = root / "ai_outputs"
ai_outputs.mkdir(exist_ok=True)

print("Running all Python tasks...\n")

for script in sorted(python_task.glob("*.py")):
    print(f"Executing {script.relative_to(root)} ...")
    try:
        subprocess.run([sys.executable, str(script)], check=True)
        print(f"✅ Success: {script.name}\n")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error in {script.name}, skipped. Exit code {e.returncode}\n")
    except Exception as e:
        print(f"❌ Unexpected error in {script.name}: {e}\n")

print("All tasks attempted. Outputs are in ai_outputs/")
