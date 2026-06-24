#!/bin/bash

REPO_DIR="${1:-.}"

# Get the local maven repository path
MVN_REPO="${HOME}/.m2/repository"

# Function to copy parent POMs
copy_parent_poms() {
    local dep_dir="$1"

    # Find all pom.xml files in the dependency directory
    while IFS= read -r pom_file; do
        # Extract groupId and artifactId from the pom
        local group_id=$(grep -oP '(?<=<groupId>)[^<]+' "$pom_file" | head -n 1)
        local artifact_id=$(grep -oP '(?<=<artifactId>)[^<]+' "$pom_file" | head -n 1)
        local version=$(grep -oP '(?<=<version>)[^<]+' "$pom_file" | head -n 1)

        # Check for parent element in pom
        if grep -q "<parent>" "$pom_file"; then
            local parent_group=$(grep -A 2 '<parent>' "$pom_file" | grep -oP '(?<=<groupId>)[^<]+' | head -n 1)
            local parent_artifact=$(grep -A 3 '<parent>' "$pom_file" | grep -oP '(?<=<artifactId>)[^<]+' | head -n 1)
            local parent_version=$(grep -A 4 '<parent>' "$pom_file" | grep -oP '(?<=<version>)[^<]+' | head -n 1)

            if [ ! -z "$parent_group" ] && [ ! -z "$parent_artifact" ] && [ ! -z "$parent_version" ]; then
                local parent_path="${MVN_REPO}/${parent_group//.//}/${parent_artifact}/${parent_version}/${parent_artifact}-${parent_version}.pom"

                if [ -f "$parent_path" ]; then
                    local target_dir="${dep_dir}/${parent_group//.//}/${parent_artifact}/${parent_version}"
                    mkdir -p "$target_dir"
                    cp "$parent_path" "$target_dir/"
                fi
            fi
        fi
    done < <(find "$dep_dir" -name "*.pom" -type f)
}

copy_parent_poms "$REPO_DIR"
echo "Parent POMs copied successfully"
