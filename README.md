## Git LFS & Pushing Changes

If you are modifying code or weights in this repository and need to push updates using Git LFS:
```
# Install Git LFS if not already available
sudo apt-get update
sudo apt-get install -y git-lfs

# Initialize and track large file formats
git lfs install
git lfs track "*.safetensors"
git lfs track "*.pt"
git lfs track "*.bin"

# Stage your tracking rules and source files
git add .gitattributes
git add arctic-wheel/pyproject.toml
git add arctic-wheel/README.md
git add arctic-wheel/src/

# Commit and push
git commit -m "add src files with Git LFS model tracking"
git remote add origin [https://github.com/kcarstons/weights.git](https://github.com/kcarstons/weights.git) 2>/dev/null || true
git branch -M main
git push origin main --force
```