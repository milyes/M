def generate_gallery_html(traces_data):
    html_blocks = []
    for data, validation in traces_data:
        block = f"""
        <div class="trace-card">
          <h2>⚡ {data['module']}</h2>
          <p>🕒 {data['timestamp']}</p>
          <p>🔐 SHA256: {data['sha256']}</p>
          <p class="{ 'valid' if validation['icon'] == '✅' else 'invalid' }">
            {validation['icon']} {validation['message']}
          </p>
          <div class="artefact">
            <a href="{TRACE_DIR}/{data['htmlcockpit']}" target="_blank">🖥️ Voir cockpit</a><br>
            <a href="{TRACE_DIR}/{data['badgesvg']}" target="_blank">🎖️ Voir badge</a><br>
            <a href="{TRACE_DIR}/{data['qrsvg']}" target="_blank">🔗 Voir QR</a>
          </div>
        </div>
        """
        html_blocks.append(block)

    full_html = open("gallery_orbitronique.html", "r").read().replace(
        "<!-- Injected dynamically via Python -->",
        "\n".join(html_blocks)
    )

    with open("gallery_orbitronique_rendered.html", "w") as f:
        f.write(full_html)
    print("✅ Galerie orbitronique générée : gallery_orbitronique_rendered.html")
