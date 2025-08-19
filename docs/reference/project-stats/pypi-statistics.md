# PyPI Download Statistics

This document provides information about tracking and monitoring download statistics for the `voice-mode` package on PyPI.

## Download Badges

The project uses [pepy.tech](https://pepy.tech) badges to display download statistics in the README. These badges automatically update to show:

- **Total Downloads**: All-time download count
- **Monthly Downloads**: Downloads in the last 30 days  
- **Weekly Downloads**: Downloads in the last 7 days

## Statistics Sources

### 1. PyPI Stats (pepy.tech)
- **URL**: https://pepy.tech/project/voice-mode
- **Features**: 
  - Real-time download counts
  - Historical download charts
  - Version-specific statistics
  - Geographic distribution data

### 2. PyPI Official Stats
- **URL**: https://pypi.org/project/voice-mode/
- **Features**:
  - Release history
  - Version download counts
  - Project metadata

### 3. Libraries.io
- **URL**: https://libraries.io/pypi/voice-mode
- **Features**:
  - Dependency tracking
  - SourceRank score
  - Release timeline
  - Community metrics

## Monitoring Downloads

### Command Line Tools

#### Using pypinfo (Google BigQuery)
```bash
# Install pypinfo
pip install pypinfo

# Get download counts for the last 30 days
pypinfo voice-mode

# Get downloads by Python version
pypinfo voice-mode pyversion

# Get downloads by operating system
pypinfo voice-mode system

# Get downloads by country
pypinfo voice-mode country
```

#### Using pypi-stats
```bash
# Install pypi-stats
pip install pypi-stats

# Get recent download stats
pypi-stats voice-mode
```

### API Access

#### PyPI JSON API
```bash
# Get package metadata including download URLs
curl https://pypi.org/pypi/voice-mode/json | jq '.info.downloads'
```

#### Libraries.io API
```bash
# Requires API key from https://libraries.io/api
curl https://libraries.io/api/pypi/voice-mode?api_key=YOUR_API_KEY
```

## Understanding Download Metrics

### What Counts as a Download
- pip install commands
- pip download commands
- Direct file downloads from PyPI
- Mirror synchronizations

### What Doesn't Count
- Cached installations
- Installations from local wheels
- Private mirror installations

### Common Inflation Factors
- CI/CD pipelines reinstalling packages
- Bot traffic and mirrors
- Development environment reinstalls

## Best Practices

1. **Track Trends, Not Absolutes**: Focus on growth patterns rather than exact numbers
2. **Compare Similar Packages**: Look at download counts for similar MCP tools
3. **Monitor Version Adoption**: Track how quickly users upgrade to new versions
4. **Geographic Distribution**: Understanding where users are helps with support and documentation

## Alternative Metrics

Beyond download counts, consider tracking:

- **GitHub Stars**: Community interest indicator
- **GitHub Issues**: User engagement and feedback
- **Discord Members**: Active community size
- **MCP Registry Stats**: Usage within the MCP ecosystem

## Automation

### GitHub Actions for Stats Collection

Create `.github/workflows/collect-stats.yml`:

```yaml
name: Collect PyPI Stats
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:

jobs:
  collect-stats:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          
      - name: Install pypinfo
        run: pip install pypinfo
        
      - name: Collect Stats
        env:
          GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_CREDENTIALS }}
        run: |
          pypinfo voice-mode > stats/downloads-$(date +%Y%m%d).txt
          pypinfo voice-mode pyversion > stats/python-versions-$(date +%Y%m%d).txt
          
      - name: Commit Stats
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add stats/
          git commit -m "Update PyPI statistics"
          git push
```

## Resources

- [PyPI Download Stats Guide](https://packaging.python.org/guides/analyzing-pypi-package-downloads/)
- [pepy.tech Documentation](https://github.com/psincraian/pepy)
- [pypinfo Documentation](https://github.com/hugovk/pypinfo)
- [Libraries.io API Docs](https://libraries.io/api)