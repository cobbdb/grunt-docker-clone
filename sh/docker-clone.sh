# Run docker against source files and
# populate a special docs branch.
# Ex) docker-clone my-repo.git src gh-pages

# Clone the repo if not already present.
if [ ! -d "docs-clone" ]; then
    if [ ! -d "docs-clone/.git" ]; then
        echo "/docs-clone/ is not a git repository!" 1>&2
        exit 1
    fi
    echo "/docs-clone/ was not found. Cloning..."
    git clone $1 -b $3 docs-clone
fi

# Clear out existing files.
echo "Removing existing doc files."
rm -rf docs-clone/*

# Run Docker against the source folder
echo "Running Docker build."
node_modules/.bin/docker -i $2 -o docs-clone

# Push the new docs.
echo "Updating docs branch."
docsmsg = "docker-bld: "
docsmsg += date
git --git-dir=docs-clone/.git --work-tree=docs-clone add -A
git --git-dir=docs-clone/.git --work-tree=docs-clone commit -m docsmsg
git --git-dir=docs-clone/.git --work-tree=docs-clone push -f origin $3
