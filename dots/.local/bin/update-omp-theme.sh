#!/bin/bash

# Definisikan path ke file sumber dan file tujuan
SCHEME_FILE="$HOME/.local/state/caelestia/scheme.json"
OMP_THEME_FILE="$HOME/.config/oh-my-posh/themes/caelestia.omp.json"

# Pastikan file scheme.json ada
if [ ! -f "$SCHEME_FILE" ]; then
    exit 1
fi

# Baca semua warna yang dibutuhkan dari scheme.json menggunakan jq
OS_BG="#$(jq -r '.colours.surface1' "$SCHEME_FILE")"
OS_FG="#$(jq -r '.colours.primary' "$SCHEME_FILE")"
SESSION_BG="#$(jq -r '.colours.surfaceContainerLow' "$SCHEME_FILE")"
SESSION_FG="#$(jq -r '.colours.secondary' "$SCHEME_FILE")"
PATH_BG="#$(jq -r '.colours.surfaceContainer' "$SCHEME_FILE")"
PATH_FG="#$(jq -r '.colours.tertiary' "$SCHEME_FILE")"
GIT_BG="#$(jq -r '.colours.mantle' "$SCHEME_FILE")"
GIT_FG="#$(jq -r '.colours.text' "$SCHEME_FILE")"
GIT_CHANGED_BG="#$(jq -r '.colours.peach' "$SCHEME_FILE")"
GIT_AHEAD_BEHIND_BG="#$(jq -r '.colours.mauve' "$SCHEME_FILE")"
GIT_AHEAD_BG="#$(jq -r '.colours.green' "$SCHEME_FILE")"
GIT_BEHIND_BG="#$(jq -r '.colours.red' "$SCHEME_FILE")"
TIME_BG="$OS_BG"
TIME_FG="$OS_FG"
PROMPT_FG="#$(jq -r '.colours.sapphire' "$SCHEME_FILE")"

# Buat ulang file caelestia.omp.json
cat << EOF > "$OMP_THEME_FILE"
{
  "\$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json", # <-- PERUBAHAN 1: Ditambahkan \ di depan $schema
  "palette": {
    "os_bg": "$OS_BG",
    "os_fg": "$OS_FG",
    "session_bg": "$SESSION_BG",
    "session_fg": "$SESSION_FG",
    "path_bg": "$PATH_BG",
    "path_fg": "$PATH_FG",
    "git_bg": "$GIT_BG",
    "git_fg": "$GIT_FG",
    "git_changed_bg": "$GIT_CHANGED_BG",
    "git_ahead_behind_bg": "$GIT_AHEAD_BEHIND_BG",
    "git_ahead_bg": "$GIT_AHEAD_BG",
    "git_behind_bg": "$GIT_BEHIND_BG",
    "time_bg": "$TIME_BG",
    "time_fg": "$TIME_FG",
    "prompt_fg": "$PROMPT_FG"
  },
  "blocks": [
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "type": "os",
          "style": "diamond",
          "leading_diamond": "\u256d\u2500\ue0b2",
          "background": "p:os_bg",
          "foreground": "p:os_fg",
          "properties": {
            "alpine": "\uf300", "arch": "\uf303", "centos": "\uf304",
            "debian": "\uf306", "elementary": "\uf309", "fedora": "\uf30a",
            "gentoo": "\uf30d", "linux": "\ue712", "macos": "\ue711",
            "manjaro": "\uf312", "mint": "\uf30f", "opensuse": "\uf314",
            "raspbian": "\uf315", "ubuntu": "\uf31c", "windows": "\ue70f"
          },
          "template": " {{ .Icon }} "
        },
        {
          "type": "session",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "background": "p:session_bg",
          "foreground": "p:session_fg",
          "template": " {{ .UserName }} "
        },
        {
          "type": "path",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "background": "p:path_bg",
          "foreground": "p:path_fg",
          "properties": {
            "style": "agnoster_short", "max_depth": 3,
            "folder_icon": "\u2026", "folder_separator_icon": " <transparent>\ue0b1</> "
          },
          "template": " {{ .Path }} "
        },
        {
          "type": "git",
          "style": "diamond",
          "leading_diamond": "<transparent,background>\ue0b0</>",
          "trailing_diamond": "\ue0b0",
          "background": "p:git_bg",
          "foreground": "p:git_fg",
          "background_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}p:git_changed_bg{{ end }}",
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}p:git_ahead_behind_bg{{ end }}",
            "{{ if gt .Ahead 0 }}p:git_ahead_bg{{ end }}",
            "{{ if gt .Behind 0 }}p:git_behind_bg{{ end }}"
          ],
          "properties": {
            "branch_template": "{{ trunc 25 .Branch }}", "fetch_status": true,
            "branch_icon": "\uf418 ", "branch_identical_icon": "\uf444", "branch_gone_icon": "\ueab8"
          },
          "template": " {{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} <transparent>\ue0b1</> <#121318>\uf044 {{ .Working.String }}</>{{ end }}{{ if .Staging.Changed }} <transparent>\ue0b1</> <#121318>\uf046 {{ .Staging.String }}</>{{ end }}{{ if gt .StashCount 0 }} <transparent>\ue0b1</> <#121318>\ueb4b {{ .StashCount }}</>{{ end }} "
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "right",
      "segments": [
        {
          "type": "executiontime",
          "style": "powerline",
          "invert_powerline": true,
          "powerline_symbol": "\ue0b2",
          "background": "p:session_bg",
          "foreground": "p:session_fg",
          "properties": { "style": "austin", "always_enabled": true },
          "template": " \ueba2 {{ .FormattedMs }} "
        },
        {
          "type": "time",
          "style": "diamond",
          "invert_powerline": true,
          "trailing_diamond": "\ue0b0",
          "background": "p:os_bg",
          "foreground": "p:os_fg",
          "properties": { "time_format": "15:04:05" },
          "template": " \uf073 {{ .CurrentDate | date .Format }} "
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "foreground": "p:prompt_fg",
          "style": "plain",
          "template": "\u2570\u2500 {{ if .Root }}#{{ else }}\${{ end }}", # <-- PERUBAHAN 2: Ditambahkan \ di depan $
          "type": "text"
        }
      ],
      "type": "prompt"
    }
  ],
  "final_space": true,
  "version": 3
}
EOF

echo "Tema Oh My Posh '$OMP_THEME_FILE' telah di-update dengan palet warna baru yang lebih kontras."

# Kirim sinyal USR1 ke semua proses zsh yang berjalan
pkill -USR1 zsh
