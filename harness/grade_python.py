# Run: `python harness/grade_python.py`
import json, pandas as pd, numpy as np
from pathlib import Path

MANIFEST = json.loads(Path("harness/task_manifest.json").read_text())

def read_csv_any(path):
    return pd.read_csv(path, keep_default_na=True)

def normalize_boolean_series(s):
    if s.dtype == bool:
        return s.astype("boolean")  # pandas nullable boolean
    if s.dtype == object:
        lowered = s.str.lower().str.strip()
        is_boolish = lowered.dropna().isin(["true","false"]).all() and lowered.notna().any()
        if is_boolish:
            return lowered.map({"true": True, "false": False}).astype("boolean")
    return s

def try_numeric(s):
    """Try to coerce a Series to numeric. If fails, return None."""
    try:
        return pd.to_numeric(s, errors="raise")
    except Exception:
        return None

def align_types(a, b):
    for col in a.columns:
        if col not in b.columns:
            continue
        a[col] = normalize_boolean_series(a[col])
        b[col] = normalize_boolean_series(b[col])
    return a, b

def df_equal(a, b, float_tol=1e-9):
    if list(a.columns) != list(b.columns):
        return False, "column order mismatch"
    if len(a) != len(b):
        return False, "row count mismatch"
    if a.shape != b.shape:
        return False, "shape mismatch"

    for col in a.columns:
        av, bv = a[col], b[col]
        av, bv = align_types(av.to_frame(), bv.to_frame())
        av, bv = av[col], bv[col]

        # NA placement must match
        if not av.isna().equals(bv.isna()):
            return False, f"NA placement mismatch in `{col}`"

        # Try to compare as numeric if possible (treat "15", "15.0" same as 15)
        av_num, bv_num = try_numeric(av.dropna()), try_numeric(bv.dropna())
        if av_num is not None and bv_num is not None:
            av_num = pd.to_numeric(av, errors="coerce")
            bv_num = pd.to_numeric(bv, errors="coerce")
            if not np.allclose(av_num.astype(float).fillna(np.nan),
                               bv_num.astype(float).fillna(np.nan),
                               equal_nan=True, rtol=0, atol=float_tol):
                return False, f"value mismatch in numeric col `{col}`"
            continue

        # Otherwise compare exact
        if not av.equals(bv):
            return False, f"value/type mismatch in `{col}`"

    return True, ""

def main():
    results = []
    for item in MANIFEST:
        k = item["id"]
        expected_path = Path(f"expected/{k:03d}.csv")
        ai_path = Path(f"ai_outputs/{k:03d}.csv")
        if not expected_path.exists():
            results.append({"id": k, "name": item["name"], "passed": False, "reason": "missing expected CSV"})
            continue
        if not ai_path.exists():
            results.append({"id": k, "name": item["name"], "passed": False, "reason": "missing ai_outputs CSV"})
            continue
        exp = read_csv_any(expected_path)
        got = read_csv_any(ai_path)
        ok, why = df_equal(got, exp)
        results.append({"id": k, "name": item["name"], "passed": bool(ok), "reason": "" if ok else why})

    df = pd.DataFrame(results)
    print(df.to_string(index=False))
    score = df["passed"].mean() * 100 if len(df) else 0.0
    print(f"\nScore: {score:.1f}%")

if __name__ == "__main__":
    main()
