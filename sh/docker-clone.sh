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
        git clone $repourl docs-clone
        (
            cd docs-clone || {
                echo "Could not find /docs-clone/!" 1>&2
                exit 1
            }
            git checkout -b cmg-pages
        )
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
node_modules/.bin/docker -i $1 -o docs-clone || {
    echo "Docker build failed." 1>&2
    exit 1
}

# Push the new docs.
echo "- Updating docs branch."
(
    cd docs-clone || {
        echo "Could not find /docs-clone/!" 1>&2
        exit 1
    }
    git add -A
    git commit -m "docker-bld: $(date)"
    git push -f origin $2
)
