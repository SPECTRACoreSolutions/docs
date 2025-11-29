# SPECTRA Framework

The SPECTRA framework provides core utilities and shared functionality for all SPECTRA projects.

## Overview

The framework is organized into stages that follow the SPECTRA methodology:

- **Source** - Data ingestion and intake
- **Extract** - Data extraction
- **Clean** - Data quality and validation
- **Transform** - Business logic
- **Refine** - Data enrichment
- **Analyse** - Analytics and insights

## Installation

```bash
pip install spectra_framework-1.7.1-py3-none-any.whl
```

## Quick Example

```python
from spectra_framework.source import SourceStage
from spectra_framework.extract import ExtractStage

# Create pipeline stages
source = SourceStage()
extract = ExtractStage()

# Process data
data = source.intake()
result = extract.process(data)
```

## Documentation

- [Architecture](architecture.md) - Framework architecture and design
- [API Reference](api.md) - Complete API documentation

