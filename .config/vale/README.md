# More pre-made vocabularies

See https://github.com/streetsidesoftware/cspell-dicts

# Creating custom vocabularies

To reuse vocabularies across projects, create a new topic directory `Topic` under
`~/.config/vale/styles/config/vocabularies` and place word lists in `accept.txt`
and `reject.txt`.

Create a project-specific `.vale.ini` containing `Vocab = <Topic>`.

You can group multiple vocabularies into one style:

```
# ~/.config/vale/styles/my-style/Vocabulary.yml
extends: vocabulary
message: "'%s' is not a recognized term."
level: error
scope: text

accept:
  - .config/vale/vocabularies/Linux/accept.txt
  - .config/vale/vocabularies/Blog/accept.txt
```

# For project-specific needs

Create a `.vale.ini` in the root directory of each project.
Reference specific styles or configuration overrides for that project.

Example `.vale.ini` for a project:

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
