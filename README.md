# tirith-iac-governance E2E — Notion case coverage

Every job here maps to a claim in the SG-4885 Notion page. Nothing is pre-baked: the binary-plan case
really runs `terraform plan`, and the negative cases really fail and are asserted to have failed.

| Workflow | Job | Notion claim under test |
|---|---|---|
| policy.yml | plan | ordinary plan run; source uploaded by default; a failing policy still COMPLETEs |
| policy.yml | plan-file | binary plan rendered in memory; no plan JSON on disk |
| policy.yml | state | tfstate.json routed to `stackguardian/json` |
| policy.yml | two-phase | state against the workflow the plan phase created (409, no update) |
| policy.yml | local | credential-free local mode; no run id |
| zero-config.yml | no-inputs-at-all | the release gate: no `with:`, no `env:`, still evaluates |
| must-fail.yml | no-credentials-and-no-policies | nothing to evaluate is RED, never green |
| must-fail.yml | tool-failure-ignores-fail-on-error | `fail-on-error` governs verdicts, not tool health |

`state.json` carries two secrets, one nested inside a `child_module`, because that nested shape is the
one that once shipped in plaintext.
