import os
import subprocess
from behave import given, when, then


@given("the LLM request secret is configured")
def step_llm_secret_configured(context):
    if not os.getenv("LLM_API_KEY"):
        context.scenario.skip("LLM_API_KEY is not set")


@when("I run the tmux LLM request script")
def step_run_llm_script(context):
    output_path = os.path.join(os.getcwd(), "bdd", "out", "llm_response.json")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    env = os.environ.copy()
    env["LLM_RESPONSE_PATH"] = output_path
    result = subprocess.run(
        ["bash", "scripts/bdd/llm_request.sh"],
        check=False,
        env=env,
        capture_output=True,
        text=True,
    )
    context.llm_result = result
    context.llm_output_path = output_path


@then("a response payload is saved")
def step_response_payload_saved(context):
    if context.llm_result.returncode != 0:
        raise AssertionError(
            f"LLM script failed with code {context.llm_result.returncode}\n"
            f"stdout:\n{context.llm_result.stdout}\n"
            f"stderr:\n{context.llm_result.stderr}"
        )
    assert os.path.isfile(context.llm_output_path), "LLM response file missing"
    assert os.path.getsize(context.llm_output_path) > 0, "LLM response file is empty"
