import os
from behave import given, then


@given("the packages repository is vendored")
def step_packages_repo(context):
    context.packages_root = os.path.join(os.getcwd(), "LibTerm-Packages")
    assert os.path.isdir(context.packages_root), "LibTerm-Packages subtree is missing"


def _list_package_files(root):
    return {entry for entry in os.listdir(root) if entry.lower().endswith(".zip")}


@then("the packages list includes required archives")
def step_packages_required(context):
    packages = _list_package_files(context.packages_root)
    required = {
        "TicTacToe.zip",
        "cowsay.zip",
        "download.zip",
        "gitdl.zip",
        "netscan.zip",
        "pager.zip",
        "pyeval.zip",
    }
    missing = sorted(required - packages)
    assert not missing, f"Missing packages: {', '.join(missing)}"
