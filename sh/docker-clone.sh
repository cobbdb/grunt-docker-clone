# Run docker against source files and
# populate a special docs branch.
# Ex) docker-clone src gh-pages
# $1 == source directory
# $2 == docs branch name

echo "Running docker-clone.sh:"

# Make sure source directory exists.
if [ ! "$1" ]; then
    echo "$1 was not found!" 1>&2
    exit 1
fi

# Clone the repo if not already present.
if [ ! -d "docs-clone" ]; then
    echo "- docs-clone was not found. Cloning..."
    repourl=$(git config --get remote.origin.url)
    if [ -z "$repourl" ]; then
        echo "No origin set for this repository!" 1>&2
        exit 1
    else
        git clone $repourl docs-clone
    fi
elif [ ! -d "docs-clone/.git" ]; then
    echo "docs-clone was found, but is not a git repository." 1>&2
    exit 1
fi

# Checkout the docs branch.
(
    echo "Checking out branch $2."
    cd docs-clone || {
        echo "Could not find docs-clone!" 1>&2
        exit 1
    }
    git checkout -b $2
)

# Clear out existing files.
echo "- Removing existing doc files."
rm -rf docs-clone/*

# Run Docker against the source folder.
echo "- Running Docker build with: docker -i $1 -o docs-clone"
node_modules/.bin/docker -i $1 -o docs-clone || {
    echo "Docker build failed." 1>&2
    exit 1
}

# Push the new docs.
echo "- Updating docs branch."
(
    cd docs-clone || {
        echo "Could not find docs-clone!" 1>&2
        exit 1
    }

    # Create an index.html page if requested.
    if [ -n "$3" ]; then
        echo "- Creating index.html from $3"
        cp $3 index.html
    fi

    # Push to origin.
    echo "- Pushing to origin/$2"
    git add -A
    git commit -m "docker-bld: $(date)"
    git push -f origin $2
)
