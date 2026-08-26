# How To Run to Make Wheel

This wheel uses Python 3.12. Create the arctic-wheel dir, cd into it then run:
```
chmod +x build_arctic_offline.sh
./build_arctic_offline.sh
```

How to install git-lfs:
```
sudo apt-get update
sudo apt-get install -y git-lfs

git lfs install
git lfs track "*.safetensors"
git lfs track "*.pt"
git lfs track "*.bin"

git add .gitattributes
git add arctic-wheel/pyproject.toml
git add arctic-wheel/README.md
git add arctic-wheel/src/


git add .gitattributes
git commit -m "Configure Git LFS for model weights"

git add arctic-wheel/src/snowflake_arctic_embed_m_v1_5/model/model.safetensors
git commit -m "Add medium 1.5 model weight via LFS"
git push origin main



git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch arctic-wheel/src/snowflake_arctic_embed_m_v1_5/model/model.safetensors" \
  --prune-empty --tag-name-filter cat -- --all


  git add arctic-wheel/src/snowflake_arctic_embed_m_v1_5/model/model.safetensors
git commit -m "Re-add model.safetensors via clean LFS history"
```
git update-ref -d HEAD


