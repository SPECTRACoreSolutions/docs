# Alana - Cloud Development Environment

Alana is SPECTRA's cloud-based AI development environment powered by Cursor IDE.

## Overview

Alana provides:

- Persistent cloud development environment
- Full Cursor IDE experience
- SSH access from anywhere
- Auto-configured tooling
- Multi-org repository support

## Quick Connect

```bash
# Add to ~/.ssh/config
Host alana
    HostName spectra-assistant-prod.up.railway.app
    Port 2222
    User alana
    IdentityFile ~/.ssh/id_rsa

# Connect via Cursor
Cmd/Ctrl+Shift+P → "Remote-SSH: Connect to Host" → alana
```

## Documentation

Full documentation available in `Core/labs/README.md` and `Core/labs/tooling/docs/alana.md`.
