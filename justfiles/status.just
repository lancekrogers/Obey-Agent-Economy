root := justfile_directory()

[private]
@default:
    just --list --justfile {{source_file()}}

# Health check across all projects
check:
    @echo "=== Submodule Status ==="
    @cd {{root}} && git submodule status
    @echo ""
    @echo "=== Go Build Check ==="
    @cd {{root}}/projects/agent-coordinator && go build ./... 2>/dev/null && echo "  coordinator   OK" || echo "  coordinator   FAILED"
    @cd {{root}}/projects/agent-inference && go build ./... 2>/dev/null && echo "  inference     OK" || echo "  inference     FAILED"
    @cd {{root}}/projects/agent-defi && go build ./... 2>/dev/null && echo "  defi          OK" || echo "  defi          FAILED"
    @echo ""
    @echo "=== Dashboard Check ==="
    @cd {{root}}/projects/dashboard && npm run build > /dev/null 2>&1 && echo "  dashboard     OK" || echo "  dashboard     FAILED"

# Check environment variable files
env:
    @echo "=== Environment Files ==="
    @test -f {{root}}/.env.docker && echo "  .env.docker               OK" || echo "  .env.docker               MISSING (cp .env.docker.example .env.docker)"
    @test -f {{root}}/projects/agent-coordinator/.env && echo "  agent-coordinator/.env    OK" || echo "  agent-coordinator/.env    MISSING"
    @test -f {{root}}/projects/agent-inference/.env && echo "  agent-inference/.env      OK" || echo "  agent-inference/.env      MISSING"
    @test -f {{root}}/projects/agent-defi/.env && echo "  agent-defi/.env           OK" || echo "  agent-defi/.env           MISSING"
    @test -f {{root}}/projects/dashboard/.env.local && echo "  dashboard/.env.local      OK" || echo "  dashboard/.env.local      MISSING"

# Show submodule status
submodules:
    cd {{root}} && git submodule status --recursive
