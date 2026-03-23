root := justfile_directory()

[private]
@default:
    just --list --justfile {{source_file()}}

# Open Remotion studio for live preview
studio:
    cd "{{root}}" && npx remotion studio

# Render video to output/obey-vault-agent-demo.mp4
render:
    cd "{{root}}" && npx remotion render src/index.ts obey-demo --output output/obey-vault-agent-demo.mp4

# Type-check the project
check:
    cd "{{root}}" && npx tsc --noEmit

# Open the rendered video
open:
    open "{{root}}/output/obey-vault-agent-demo.mp4"
