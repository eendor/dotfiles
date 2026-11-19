#
# ~/.bashrc
#

# Clean up any legacy third-party proxy environment variables
unset ANTHROPIC_BASE_URL ANTHROPIC_API_KEY ANTHROPIC_MODEL ANTHROPIC_DEFAULT_MODEL \
      ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL \
      ANTHROPIC_DEFAULT_FABLE_MODEL ANTHROPIC_CUSTOM_MODEL_OPTION \
      ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION ANTHROPIC_DEFAULT_SONNET_MODEL_DESCRIPTION \
      ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION ANTHROPIC_DEFAULT_FABLE_MODEL_DESCRIPTION \
      ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION ANTHROPIC_CUSTOM_MODEL_OPTION_NAME \
      ANTHROPIC_DEFAULT_OPUS_MODEL_NAME ANTHROPIC_DEFAULT_SONNET_MODEL_NAME \
      ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME ANTHROPIC_DEFAULT_FABLE_MODEL_NAME

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Added by Antigravity CLI installer
export PATH="/home/rodnee/.local/bin:$PATH"
agy-plugins-update() {
  { for d in ~/.gemini/config/plugins/ponytail ~/.gemini/config/plugins/superpowers ~/.gemini/config/plugins/mattpocock-skills; do
      git -C "$d" pull --ff-only -q 2>/dev/null
    done
    for cat in engineering productivity misc; do
      for s in ~/.gemini/config/plugins/mattpocock-skills/skills/$cat/*; do
        [[ -f "$s/SKILL.md" ]] && ln -sf "$cat/$(basename "$s")" ~/.gemini/config/plugins/mattpocock-skills/skills/ 2>/dev/null
      done
    done
  } &>/dev/null &
}
agy() { agy-plugins-update; command agy --dangerously-skip-permissions "$@"; }

# Claude Code CLI (Official Claude Pro)
alias claude="command claude --dangerously-skip-permissions --strict-mcp-config --system-prompt ''"
unset DISABLE_AUTO_COMPACT DISABLE_COMPACT CLAUDE_CODE_EXPERIMENTAL_CODE_MODE
export CLAUDE_CODE_TMPDIR="/home/rodnee/.claude/tmp"
export CLAUDE_CODE_DANGEROUSLY_DISABLE_SANDBOX="1"
export CLAUDE_CODE_NO_MODEL_FALLBACK="1"
export CLAUDE_CODE_DISABLE_1M_CONTEXT="1"
export CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS="1"
export CLAUDE_CODE_SKIP_PLUGIN_MCP_SERVERS="1"
export ENABLE_CLAUDEAI_MCP_SERVERS="false"
export CLAUDE_CODE_DISABLE_WORKFLOWS="1"
export CLAUDE_CODE_DISABLE_PROACTIVITY="1"
export CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL="1"
export CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS="1"
export CLAUDE_CODE_DISABLE_CLAUDE_MDS="1"
export CLAUDE_CODE_DISABLE_AUTO_MEMORY="1"
export CLAUDE_CODE_DISABLE_ORG_MEMORY="1"
export CLAUDE_CODE_DISABLE_BUNDLED_SKILLS="1"
export CLAUDE_CODE_DISABLE_POLICY_SKILLS="1"
export CLAUDE_CODE_DISABLE_CLAUDE_API_SKILL="1"
export CLAUDE_CODE_DISABLE_CLAUDE_CODE_SKILL="1"
export CLAUDE_CODE_SYNC_SKILLS="false"
export CLAUDE_CODE_SYNC_PLUGINS="false"
export FORCE_PROMPT_CACHING_5M="1"
export CLAUDE_CODE_PROMPT_CACHE_TTL="5m"
export CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL="5m"
export CLAUDE_CODE_MESSAGES_PROMPT_CACHE_TTL="5m"
export CLAUDE_CODE_NORMALIZE_PREFIX_CACHE="1"
export CLAUDE_CODE_SUBAGENT_CACHE_EVICT="1"
export CLAUDE_CODE_DISABLE_ADVISOR_TOOL="1"

# Cursor CLI Agent - YOLO mode / always bypass permissions
alias agent='command agent --yolo --trust --approve-mcps'
alias cursor-agent='command cursor-agent --yolo --trust --approve-mcps'
alias cursor='command agent --yolo --trust --approve-mcps'

# GitHub Copilot CLI - YOLO mode / always bypass permissions
export COPILOT_ALLOW_ALL="true"
copilot() { command copilot --allow-all "$@"; }


export PATH="$HOME/.opencode/bin:$PATH"
