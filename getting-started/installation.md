# Installation

## Installing SPECTRA Framework

The SPECTRA framework is distributed as a Python wheel package.

### From Wheel File

```bash
pip install spectra_framework-1.7.1-py3-none-any.whl
```

### From Source

```bash
cd Data/framework
pip install -e .
```

## Development Setup

For development, install with dev dependencies:

```bash
cd Data/framework
pip install -e ".[dev]"
```

## Verify Installation

```bash
python -c "import spectra_framework; print(spectra_framework.__version__)"
```

## Next Steps

- [Quick Start Guide](quick-start.md) - Build your first pipeline
- [Framework Documentation](../framework/index.md) - Learn about core utilities

