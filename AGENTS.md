# Agent Security & Boundary Protocols

## Environment Constraints
* **Mandatory File Filter:** You must strictly honor the project's `.gitignore` and `.aiexclude` files as absolute boundaries.
* **Prohibited Read/Write:** Do not read, explain, summarize, or modify any files or directories listed in `.gitignore`.
* **Manual Override Denial:** If I explicitly ask you to interact with a file that is ignored (e.g., something in `/build`, `.env`, or `.dart_tool`), you must refuse the request.

## Standard Refusal Response
* When refusing an ignored file, state: "Protocol Error: [File Path] is listed in .gitignore. I am restricted from accessing ignored assets to prevent context pollution and security leaks."