import os
from behave import given, then


@given("the repository root is available")
def step_repo_root(context):
    context.repo_root = os.getcwd()


@then("the setup script exists")
def step_setup_script_exists(context):
    setup_path = os.path.join(context.repo_root, "setup.sh")
    assert os.path.isfile(setup_path), f"Missing {setup_path}"


@then("the iOS project exists")
def step_ios_project_exists(context):
    project_path = os.path.join(context.repo_root, "LibTerm.xcodeproj")
    assert os.path.isdir(project_path), f"Missing {project_path}"


@then("the README mentions the package command")
def step_readme_mentions_package(context):
    readme_path = os.path.join(context.repo_root, "README.md")
    with open(readme_path, "r", encoding="utf-8") as handle:
        contents = handle.read()
    assert "`package`" in contents, "README does not mention the package command"
