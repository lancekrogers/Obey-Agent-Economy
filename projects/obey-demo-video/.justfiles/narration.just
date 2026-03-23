root := justfile_directory()

[private]
@default:
    just --list --justfile {{source_file()}}

# Generate all narration WAV clips with Kokoro TTS (af_bella)
generate:
    cd "{{root}}" && uv run --with kokoro-onnx --with soundfile python narration/generate.py

# Regenerate narration and render video
all: generate
    cd "{{root}}" && npx remotion render src/index.ts obey-demo --output output/obey-vault-agent-demo.mp4
