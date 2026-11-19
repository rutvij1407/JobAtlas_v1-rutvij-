# JobAtlas: Job Market Dashboard for F1 International Students

Live site: https://jobatlas-f1-dashboard.vercel.app

A multi page Plotly Dash app that helps F1 international students in the USA see where sponsoring employers hire, what goes wrong in their applications, and how their resume reads to an applicant tracking system.

## Pages

| Route | Page | What it shows |
|-------|------|---------------|
| `/` | USA Map | Choropleth of H1B petitions and job postings by state. Hover for the state name, click to open the state detail page |
| `/state/<code>` | State detail | The same map style and filters for one state |
| `/mistakes` | Job Mistakes | Common application mistakes (for example LinkedIn redirecting to its own form instead of the employer site), by type and source |
| `/h1b` | H1B Market | Sponsorship trends by state, industry and company type, plus a 90 day posting trend |
| `/candidate` | Candidate Analysis | Upload a PDF or DOCX resume and an optional job description to get a keyword based ATS score, missing keywords and suggestions |
| `/data-engineer` | Data Engineer | Pipeline status, last refresh time and a day by day work log |
| `/map-view` | Google Maps view | Optional map that reads `/api/h1b.kml` (needs `GOOGLE_MAPS_API_KEY`) |

Filters cover date range, job type, company type, industry, application source and mistake type.

## About the data

The current build runs on **synthetic sample data** generated with fixed random seeds in `backend/data_loader.py`, so every page works with no downloads or API keys. The refresh job in `jobs/daily_refresh.py` writes these tables to `data/processed/` and records pipeline status. Swapping in the public USCIS H1B Employer Data Hub and DOL LCA disclosure files is the next step on the roadmap.

## Run locally

```bash
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt

python3 jobs/daily_refresh.py   # optional: writes the processed tables
python3 run.py                  # serves on port 8051 (set PORT to change it)
```

Then open http://127.0.0.1:8051.

## Project layout

```
backend/            data loading and services (H1B analytics, mistakes, resume analyzer, KML, pipeline status)
config/settings.py  paths, states, filter values
dashboards/         Dash app, pages, shared filter components and CSS
jobs/               daily refresh job
data/               processed tables and the data engineer log
docs/               Google Maps setup and data engineer notes
deploy_vercel.sh    builds a slim copy and deploys it to Vercel as a Flask function
```

## Tech stack

Python, Plotly Dash, Dash Bootstrap Components, pandas, NumPy, pdfplumber and python-docx for resume parsing, Flask (Dash server) and Vercel.

## Roadmap

* Load real USCIS H1B Employer Data Hub and DOL LCA files in the refresh job
* Store tables in DuckDB or Postgres instead of flat files
* Schedule the refresh with GitHub Actions

Full design notes are in [PROJECT_SPECIFICATION.md](PROJECT_SPECIFICATION.md).
