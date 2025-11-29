# Quick Start

Build your first SPECTRA pipeline in minutes.

## Create a New Project

```bash
# Navigate to Data directory
cd Data

# Create your project directory
mkdir my-project
cd my-project
```

## Project Structure

```
my-project/
├── README.md
├── pyproject.toml
├── src/
│   └── my_project/
│       ├── __init__.py
│       └── pipeline.py
└── tests/
    └── test_pipeline.py
```

## Example Pipeline

```python
from spectra_framework.source import SourceStage
from spectra_framework.extract import ExtractStage

class MyPipeline:
    def __init__(self):
        self.source = SourceStage()
        self.extract = ExtractStage()
    
    def run(self):
        data = self.source.intake()
        extracted = self.extract.process(data)
        return extracted
```

## Run Your Pipeline

```bash
python -m my_project.pipeline
```

## Next Steps

- [Framework Documentation](../framework/index.md) - Explore available utilities
- [Standards](../standards/index.md) - Learn SPECTRA conventions

