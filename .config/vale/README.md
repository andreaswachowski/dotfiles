# Creating custom vocabularies

To reuse vocabularies across projects, create a `vocabularies` directory under
`~/.config/vale/` and reference those files in a custom style, e.g.
"Vocabulary.yml":

```
# ~/.config/vale/styles/my-style/Vocabulary.yml
extends: vocabulary
message: "'%s' is not a recognized term."
level: error
scope: text

accept:
  - .config/vale/vocabularies/common.txt
  - .config/vale/vocabularies/project1.txt
```

For project-specific needs:

    Create a .vale.ini in the root directory of each project.
    Reference specific styles or configuration overrides for that project.

Example .vale.ini for a project:

```
StylesPath = ~/.config/vale/styles
MinAlertLevel = suggestion

# Include specific styles:
[*.md]
BasedOnStyles = my-style

# Add project-specific vocabularies:
[*.txt]
BasedOnStyles = my-style, another-style
```
