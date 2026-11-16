# Unofficial Braiins Farm Proxy Add-ons for Home Assistant

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://home-assistant.io)](https://home-assistant.io)

Unofficial community Home Assistant add-on repository for running **Braiins Farm Proxy** (Stratum V1) together with its built-in **Web GUI**, **Prometheus** metrics database, and pre-configured **Grafana** monitoring dashboards.

## System Requirements

* **Architecture:** **`amd64` (x86_64) only** — works on standard PCs, mini-PCs (Intel NUC, Beelink, etc.), and x86 VMs. **Not compatible with Raspberry Pi (`arm64` / `armv7`)**, as the upstream Braiins Farm Proxy image only provides `amd64` builds.
* **Home Assistant:** Home Assistant OS or Home Assistant Supervised (with Add-on Store support).

## Included Add-ons

1. **Braiins Farm Proxy (`braiins_proxy`)**
   * Core Stratum V1 mining proxy (`braiinssystems/farm-proxy:26.02`) listening on ports `3333–3339`.
   * Built-in Web GUI on port `7777` for managing servers, pool targets, and routing rules.
   * Automatic live configuration reloading (`configure --watch`).
2. **Prometheus (`prometheus`)**
   * Pre-configured time-series database scraping metrics from `local-braiins-proxy:8080` every 5 seconds.
   * Exposes web UI and API on port `9090`.
3. **Grafana (`grafana`)**
   * Pre-provisioned with the Prometheus data source (`http://local-prometheus:9090`) and official Braiins Farm Proxy dashboards (`Farm Proxy Dashboard` & `Debug Dashboard`).
   * Anonymous viewer access and iframe embedding enabled out of the box on port `3000`.

---

## Installation

### Automatic (1-Click)
1. Click the **Add Repository to My Home Assistant** badge at the top of this page.
2. Refresh the Add-on Store page (`F5`).

### Manual
1. In Home Assistant, navigate to **Settings** → **Apps (Add-ons)** → **Add-on Store**.
2. Click the **three dots** menu in the top right corner and select **Repositories**.
3. Paste the URL of this repository:
   ```text
   https://github.com/Jabber-se/ha-braiins-proxy-addons
   ```
4. Click **Add**, close the dialog, and refresh the page.

---

## Quick Start Guide

1. **Install and start the add-ons** in the following order (enable **Start on boot** for each):
   * **Prometheus (Braiins Metrics)**
   * **Braiins Farm Proxy**
   * **Grafana (Braiins Monitoring)**
2. **Configure your mining profile:**
   * Open the Braiins Farm Proxy Web GUI at `http://<YOUR_HA_IP>:7777`.
   * Select the default `main` profile, enter your pool URL and worker credentials, and click **Activate**.
3. **Point your ASIC miners to the proxy:**
   * Set your miner's pool URL to `stratum+tcp://<YOUR_HA_IP>:3333`.
4. **View live analytics:**
   * Open Grafana at `http://<YOUR_HA_IP>:3000` to view real-time hashrate, accepted shares, and connection metrics.

---

## Adding to the Home Assistant Sidebar

Because the Braiins Web GUI uses root-relative asset paths, standard Home Assistant Ingress is disabled. You can embed both interfaces directly into your sidebar using Webpage dashboards:

1. Go to **Settings** → **Dashboards** → **Add Dashboard**.
2. Set the title (e.g., `Braiins Proxy`), icon (`mdi:pickaxe`), and URL path (`braiins-proxy`), then click **Create**.
3. Open the new dashboard, click the **Edit (pencil)** icon → edit the view tab → enable **Panel (1 card)** mode.
4. Add a **Webpage** card pointing to `http://<YOUR_HA_IP>:7777` and save.
5. Repeat the same steps for **Grafana** using icon `mdi:chart-areaspline` and URL `http://<YOUR_HA_IP>:3000`.

---

## Persistent Data Storage

All configuration files, profiles, and metrics databases are stored in your Home Assistant `/share` directory so they persist across add-on updates:

* `/share/braiins_proxy/config/` — TOML configuration profiles (`active_profile.toml`, `main.toml`, etc.)
* `/share/prometheus/` — `prometheus.yml` and time-series data
* `/share/braiins_grafana/` — Grafana database, provisioning files, and dashboards

---

## Disclaimer & License

This is an unofficial community wrapper designed to simplify deployment on Home Assistant. All core software components belong to their respective authors:
* [Braiins Farm Proxy](https://github.com)
* [Prometheus](https://prometheus.io)
* [Grafana](https://grafana.com)

Wrapper scripts and add-on definitions in this repository are licensed under the **MIT License**.

