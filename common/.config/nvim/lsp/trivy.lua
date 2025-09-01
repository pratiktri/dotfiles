return {
    cmd = { "trivy", "server" },
    filetypes = { "dockerfile", "yaml", "json" },
    root_markers = { ".git", "Dockerfile", "docker-compose.yaml" },
}
