# Agent Security & Boundary Protocols

## Environment Constraints
* **Mandatory File Filter:** You must strictly honor the project's `.gitignore` and `.aiexclude` files as absolute boundaries.
* **Prohibited Read/Write:** Do not read, explain, summarize, or modify any files or directories listed in `.gitignore`.
* **Manual Override Denial:** If I explicitly ask you to interact with a file that is ignored (e.g., something in `/build`, `.env`, or `.dart_tool`), you must refuse the request.

## Standard Refusal Response
* When refusing an ignored file, state: "Protocol Error: [File Path] is listed in .gitignore. I am restricted from accessing ignored assets to prevent context pollution and security leaks."

## AI Rule Reference

When editing the codebase:
1. For any files under `lib/features/`, read the local architectural instructions in [feature_architecture.md](file:///C:/Users/Saurabh/AndroidStudioProjects/splittr/docs/ai_rules/feature_architecture.md).
2. When importing or working with a `sky_*` package, read its `SKILL.md` rule file:
   - Primary Source: Locate the package's root path by parsing `splittr/.dart_tool/package_config.json` (under `packages` where `name` is the package name). Read the `SKILL.md` from the resolved directory path.
   - Secondary Source: If the file cannot be resolved locally, fetch the raw file from the GitHub remote repository:
     `https://raw.githubusercontent.com/Saurrabhh/sky_core/main/packages/<package_name>/SKILL.md`