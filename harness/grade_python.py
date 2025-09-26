# Run: `python harness/grade_python.py`
import importlib.util, sys, json, pandas as pd, numpy as np
from pathlib import Path

MANIFEST = json.loads(Path("harness/task_manifest.json").read_text())

def read_expected(k):
    return pd.read_parquet(f"expected/{k:03d}.parquet")

def df_equal(a, b, float_tol=1e-9):
    if list(a.columns) != list(b.columns):
        return False, "column order mismatch"
    if len(a) != len(b):
        return False, "row count mismatch"
    if a.shape != b.shape:
        return False, "shape mismatch"
    for col in a.columns:
        av, bv = a[col], b[col]
        if not av.isna().equals(bv.isna()):
            return False, f"NA placement mismatch in `{col}`"
        if pd.api.types.is_float_dtype(av) and pd.api.types.is_float_dtype(bv):
            if not np.allclose(av.fillna(np.nan), bv.fillna(np.nan), equal_nan=True, rtol=0, atol=float_tol):
                return False, f"value mismatch in float col `{col}`"
        else:
            if not av.equals(bv):
                return False, f"value/type mismatch in `{col}`"
    return True, ""

def run_task(py_path):
    spec = importlib.util.spec_from_file_location("task", py_path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules["task"] = mod
    spec.loader.exec_module(mod)
    if not hasattr(mod, "out"):
        raise AssertionError(f"{py_path} must define a DataFrame variable named `out`")
    out = mod.out
    if hasattr(out, "to_pandas"):
        out = out.to_pandas()
    import pandas as pd
    assert isinstance(out, type(pd.DataFrame())), "`out` must be a DataFrame"
    return out

def main():
    results = []
    for item in MANIFEST:
        k = item["id"]
        expected_path = Path(f"expected/{k:03d}.parquet")
        if not expected_path.exists():
            print(f"[WARN] Missing expected/{k:03d}.parquet — run R tasks to generate ground truth.")
            results.append({"id": k, "name": item["name"], "passed": False, "reason": "no expected"})
            continue
        exp = read_expected(k)
        try:
            got = run_task(f"ai_outputs/{k:03d}.py")
            ok, why = df_equal(got, exp)
            results.append({"id": k, "name": item["name"], "passed": bool(ok), "reason": why})
        except Exception as e:
            results.append({"id": k, "name": item["name"], "passed": False, "reason": str(e)})
    df = pd.DataFrame(results)
    print(df.to_string(index=False))
    score = df["passed"].mean() * 100 if len(df) else 0.0
    print(f"\\nScore: {score:.1f}%")
if __name__ == "__main__":
    main()
