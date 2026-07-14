# Mac Mini — Remote Access & Tailscale Recovery

A step-by-step guide to (1) get remote access to the Mac Mini via AnyDesk and
(2) cleanly re-add it to Tailscale with its own identity.

**Background:** The laptop was set up from the Mac Mini via Migration Assistant,
so both machines ended up sharing **one Tailscale identity** ("Duplicate node
key"). That collision is what broke remote access. The permanent fix is to give
the Mac Mini a **fresh Tailscale install** so it becomes its own member.

---

## Part 1 — Install & connect AnyDesk (laptop version)

### On the Mac Mini (helper does this, first time only)
1. Open **Safari**, go to **anydesk.com**, click **Download**.
2. Open the downloaded file, drag **AnyDesk** into **Applications** (or double-click to run).
3. If macOS warns the app is from the internet, click **Open**.
4. AnyDesk shows a **9-digit number** under **"This Desk."** → note this number.

### On your laptop
5. Go to **anydesk.com** → **Download** → open AnyDesk.
6. In the **"Remote Desk"** box at the top, type the **9-digit number** from step 4.
7. Press **Enter**.

### Approve the connection (on the Mac Mini)
8. A pop-up appears on the Mac Mini → click **Accept**.
9. **First time only:** the screen may be black. AnyDesk shows a checklist —
   click each **"Open Settings"** button and turn ON the AnyDesk switches for:
   - **Screen Recording** (so you can see the screen)
   - **Accessibility** (so you can control mouse/keyboard)
10. If prompted, **quit and reopen AnyDesk**, then reconnect with the same number.

✅ You should now see and control the Mac Mini from your laptop.

---

## Part 2 — Unattended access (so you never need the helper again)

Do this on the **first** session, while the helper is still available.

On the Mac Mini's AnyDesk:
1. Open **Settings** (gear / ☰ menu).
2. Go to **Security**.
3. Click **Unlock Security Settings** (enter the Mac's password if asked).
4. Turn ON **Enable unattended access**.
5. Set a **strong password** (this is your remote key — keep it private).

Also:
- **Settings → General → "Start AnyDesk with system"** → ON (always running after reboot).
- Save the **9-digit address** somewhere handy (it doesn't change).

From now on: connect with the 9-digit address → enter the unattended password →
you're in. No one needs to click Accept.

---

## Part 3 — Keep it reachable when the screen is off

| State | Reachable? |
|-------|-----------|
| Display off (Mac awake) | ✅ Yes |
| Mac asleep | ❌ No |

Prevent the Mac from sleeping — **System Settings → Energy**:
- **"Prevent automatic sleeping when the display is off"** → ON
- **"Wake for network access"** → ON
- "Turn display off after…" is fine (display-only).

Headless note: if **no monitor** is plugged in, AnyDesk may show a black/tiny
screen. Fix with a cheap **HDMI "dummy display" plug**. If a monitor is attached
(even switched off), no plug needed.

---

## Part 4 — Cleanly re-add the Mac Mini to Tailscale

A plain re-login won't work — both machines share one identity, so logging in
just recreates the collision. The Mac Mini needs a **fresh install** to generate
a new identity.

### On the Mac Mini (via AnyDesk)
1. Open **Terminal** and run:
   ```
   sudo tailscale logout
   ```
2. Quit Tailscale (menu-bar icon → **Quit**), drag **Tailscale** from
   **Applications** to the **Trash**, empty the Trash.
3. Reinstall: Safari → **https://tailscale.com/download/mac** → download → run installer.
4. Open Tailscale → **Log in** → sign in with **kf.bankowski@gmail.com**.
5. Let its hostname be **krzsztofs-mac-mini** (distinct from the laptop).

### Verify
```
tailscale status
```
- ✅ **Success:** Mac Mini shows a **new, different 100.x.y.z IP** (not `100.106.171.102`).
- ❌ **If it comes back on `100.106.171.102`** (still merged), the old identity
  file survived — run this, then log in again:
  ```
  sudo tailscale logout
  sudo rm -f /Library/Tailscale/tailscaled.state
  sudo tailscale up --hostname krzsztofs-mac-mini
  ```

### Back on the laptop
1. Bring Tailscale up:
   ```
   sudo tailscale up --hostname katarzynas-macbook-pro
   ```
2. Confirm two separate machines:
   ```
   tailscale status
   ```
   You should see **both** `katarzynas-macbook-pro` and `krzsztofs-mac-mini` at
   **different IPs**. No more duplicate. 🎉

### Lock it in
- **Disable key expiry** on the Mac Mini: admin console
  (login.tailscale.com/admin/machines) → click the machine → **⋯ → Disable key
  expiry**. (Key expiry is what caused the drop-off.)
- You now also have **AnyDesk unattended access** as a backup route.

---

## Part 5 — Attach to your tmux session from the laptop

```
ssh -t <macmini-username>@<macmini-new-ip> tmux attach -d -t spendmod
```

Notes:
- **SSH (via Tailscale)** is screen-independent — best for terminal/tmux work.
- **AnyDesk** is the GUI backup / rescue route if Tailscale ever breaks again.

---

## Quick reference — the two access routes

| Route | Needs | Best for |
|-------|-------|----------|
| SSH over Tailscale | Tailscale up on both, Mac Mini's IP | tmux / terminal work, screen off |
| AnyDesk (unattended) | 9-digit address + password | GUI access, Tailscale-independent rescue |
