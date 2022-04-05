# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

aws cloudformation deploy --template-file pipeline.yml \
    --stack-name "how-and-when-policy-blog-pipeline" \
    --capabilities CAPABILITY_NAMED_IAM


PARENT_COMMIT_ID=$(aws codecommit get-branch --repository-name sample-repo --branch-name main --query branch.commitId --output text)

echo "$PARENT_COMMIT_ID"
if [ -z "$PARENT_COMMIT_ID" ]; then
    echo "Creating branch with initial commit.."
    aws codecommit put-file --repository-name sample-repo --branch-name main \
        --file-path "application.yml" --file-content file://sample-application.yml \
        --cli-binary-format raw-in-base64-out
else
    echo "Committing latest copy of application template.."
    aws codecommit put-file --repository-name sample-repo --branch-name main \
        --file-path "application.yml" --file-content file://sample-application.yml \
        --parent-commit-id $PARENT_COMMIT_ID --cli-binary-format raw-in-base64-out
fi