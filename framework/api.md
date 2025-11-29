# Framework API Reference

Complete API documentation for the SPECTRA framework.

## Source Stage

```python
from spectra_framework.source import SourceStage

stage = SourceStage()
data = stage.intake()
```

## Extract Stage

```python
from spectra_framework.extract import ExtractStage

stage = ExtractStage()
extracted = stage.process(data)
```

## Clean Stage

```python
from spectra_framework.clean import CleanStage

stage = CleanStage()
cleaned = stage.process(data)
```

## Transform Stage

```python
from spectra_framework.transform import TransformStage

stage = TransformStage()
transformed = stage.process(data)
```

## Refine Stage

```python
from spectra_framework.refine import RefineStage

stage = RefineStage()
refined = stage.process(data)
```

## Analyse Stage

```python
from spectra_framework.analyse import AnalyseStage

stage = AnalyseStage()
results = stage.process(data)
```

## Utilities

### Logging

```python
from spectra_framework.logging import get_logger

logger = get_logger(__name__)
logger.info("Message")
```

### Configuration

```python
from spectra_framework.config import load_config

config = load_config("config.yaml")
```

