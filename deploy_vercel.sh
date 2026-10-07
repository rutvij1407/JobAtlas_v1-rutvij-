#!/bin/bash
# Deploy the Dash dashboard to Vercel (project: jobatlas-f1-dashboard).
# Stages a lean copy (no venv, slim requirements, Flask entrypoint) so the
# Python function stays under Vercel's size limit.
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
STAGE="${TMPDIR:-/tmp}/jobatlas-vercel"
rm -rf "$STAGE" && mkdir -p "$STAGE"
rsync -a --exclude __pycache__ --exclude 'uploads/*' "$ROOT"/{backend,config,dashboards,data,jobs} "$STAGE/"

cat > "$STAGE/requirements.txt" <<'REQ'
dash>=2.14.0
dash-bootstrap-components>=1.5.0
plotly>=5.18.0
pandas>=2.1.0
numpy>=1.26.0
flask
pdfplumber>=0.10.0
python-docx>=1.1.0
python-dotenv>=1.0.0
requests>=2.31.0
REQ

cat > "$STAGE/app.py" <<'PY'
from dashboards.app_dash import app as dash_app

app = dash_app.server
PY

cd "$STAGE"
vercel link --yes --project jobatlas-f1-dashboard
vercel deploy --prod --yes
