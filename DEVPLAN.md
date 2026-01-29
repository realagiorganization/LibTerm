# LibTerm Development Plan

## Goals
- Keep core app features stable while modernizing CI, releases, and automation.
- Document dependency setup so local builds and CI remain reproducible.
- Validate critical workflows with BDD coverage and recorded console interactions.

## External Dependencies
- Xcode (current macOS toolchain) for builds and signing.
- Ruby + Fastlane for build automation and TestFlight uploads.
- App Store Connect API key (key id, issuer id, base64 key content).
- Git submodules (ios_system, llvm, bc frameworks).
- Command-line tools: `curl`, `tar`, `make`, `tmux` (for VHS/BDD recording).
- GitHub Actions secrets for CI/TestFlight/LLM requests.

## Local Setup
1. Install Xcode and accept the license agreement.
2. Ensure `ruby`, `python3`, and `tmux` are available locally.
3. Run `./setup.sh` to fetch ios_system, llvm, and bc artifacts.
4. Open `LibTerm.xcodeproj` and build the `LibTerm` scheme.

## CI Workflow Overview
1. iOS CI builds with Fastlane (`fastlane ci_build`).
2. BDD workflow installs Python requirements and runs `behave`.
3. VHS workflow records the LLM request tape and commits the GIF artifact.
4. TestFlight workflow uses Fastlane `beta` lane with App Store Connect API key.

## Release Checklist
1. Confirm `APP_IDENTIFIER` and `APPLE_TEAM_ID` secrets are correct.
2. Validate the signing configuration and provisioning profiles.
3. Tag the release (e.g., `v1.2.3`) to trigger TestFlight workflow.
4. Verify TestFlight build processing in App Store Connect.

## BDD Coverage
- Project structure checks.
- README documentation validation.
- LLM request via tmux-driven script using encrypted secrets.

## Artifact Updates
- `docs/media/llm_request.gif` recorded via VHS in CI.
- README badge updates for CI/BDD/TestFlight/VHS workflows.
