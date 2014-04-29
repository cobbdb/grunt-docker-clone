# Run docker against source files and
# populate a special docs branch.
# Ex) docker-clone src gh-pages

echo "Running docker-clone.sh:"

# Make sure source directory exists.
if [ ! "$1" ]; then
    echo "$1 was not found!" 1>&2
    exit 1
fi

# Clone the repo if not already present.
if [ ! -d "docs-clone" ]; then
    echo "- /docs-clone/ was not found. Cloning..."
    repourl=$(git config --get remote.origin.url)
    if [ -z "$repourl" ]; then
        echo "No origin set for this repository!" 1>&2
        exit 1
    else
        git clone $repourl -b $2 docs-clone || {
            echo "Could not find branch $2 on origin." 1>&2
            exit 1
        }
    fi
elif [ ! -d "docs-clone/.git" ]; then
    echo "/docs-clone/ was found, but is not a git repository." 1>&2
    exit 1
fi

# Clear out existing files.
echo "- Removing existing doc files."
rm -rf docs-clone/*

# Run Docker against the source folder
echo "- Running Docker build with: docker -i $1 -o docs-clone"
node_modules/.bin/docker -i $1 -o docs-clone

# Push the new docs.
echo "- Updating docs branch."
docsmsg="docker-bld: "
docsmsg+=date
git --git-dir=docs-clone/.git --work-tree=docs-clone add -A
git --git-dir=docs-clone/.git --work-tree=docs-clone commit -m docsmsg
git --git-dir=docs-clone/.git --work-tree=docs-clone push -f origin $2
