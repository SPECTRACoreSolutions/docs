#!/usr/bin/env python3
"""
Aggregate documentation from across the SPECTRA monorepo.

This script collects README files and documentation from various
project directories and prepares them for inclusion in the docs site.
"""

import os
import shutil
from pathlib import Path
from typing import List, Tuple


def find_docs(root: Path, patterns: List[str]) -> List[Tuple[Path, str]]:
    """Find documentation files matching patterns."""
    docs = []
    for pattern in patterns:
        for doc_file in root.rglob(pattern):
            if should_include(doc_file):
                rel_path = doc_file.relative_to(root)
                docs.append((doc_file, str(rel_path)))
    return docs


def should_include(path: Path) -> bool:
    """Determine if a file should be included in documentation."""
    # Skip hidden directories and common exclusions
    exclusions = {
        '.git', 'node_modules', '__pycache__', '.venv', 'venv',
        'dist', 'build', 'htmlcov', '.pytest_cache'
    }
    
    parts = path.parts
    if any(part in exclusions for part in parts):
        return False
    
    # Skip backup directories
    if 'backup' in path.parts or 'old' in path.parts:
        return False
    
    return True


def aggregate_readmes(root: Path, output_dir: Path):
    """Aggregate README files from projects."""
    readmes = find_docs(root, ['README.md', 'README.txt'])
    
    projects_dir = output_dir / 'projects'
    projects_dir.mkdir(parents=True, exist_ok=True)
    
    # Track processed projects to avoid duplicates
    processed = set()
    
    for readme_path, rel_path in readmes:
        # Skip root README and docs directory
        if rel_path == 'README.md' or 'docs/' in rel_path:
            continue
        
        # Extract project name from path
        parts = Path(rel_path).parts
        project_name = None
        
        # Find project name (first non-root directory)
        if len(parts) > 1:
            if parts[0] in ['Core', 'Data', 'Engagement', 'Security']:
                if len(parts) > 1:
                    project_name = parts[1]
            else:
                project_name = parts[0]
        
        if project_name and project_name not in ['docs', 'dist', 'build']:
            # Normalize project name
            normalized = project_name.lower().replace('_', '-')
            
            if normalized not in processed:
                dest = projects_dir / f"{normalized}.md"
                # Copy or create symlink
                if readme_path.exists():
                    shutil.copy2(readme_path, dest)
                    print(f"Aggregated: {rel_path} -> {dest.name}")
                    processed.add(normalized)


def main():
    """Main aggregation function."""
    script_dir = Path(__file__).parent
    docs_dir = script_dir.parent
    # From Core/docs, go up to Core, then up to workspace root
    workspace_root = docs_dir.parent.parent
    
    print(f"Workspace root: {workspace_root}")
    print(f"Docs directory: {docs_dir}")
    
    # Aggregate READMEs from workspace
    aggregate_readmes(workspace_root, docs_dir)
    
    print("\nDocumentation aggregation complete!")


if __name__ == '__main__':
    main()

