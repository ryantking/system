# config.nu: Nushell configuration

use lib.nu preview_file

source vars.nu

source ~/.cache/nushell/bash-env.nu
source ~/.cache/nushell/did_you_mean.nu

const menu_style = {
  text: blue
  selected_text: blue_reverse
  description_text: white
}

$env.config = {
  show_banner: false
  buffer_editor: "hx"
  table: {
    mode: "light"
  }

  history: {
    file_format: sqlite
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true
  }

  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: $menu_style
    } 
    {
      name: history_menu
      only_buffer_difference: true 
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: $menu_style
    }
  ]

  keybindings:  [
    {
      name: reload_config
      modifier: none
      keycode: f5
      mode: [emacs vi_normal vi_insert]
      event: {
        send: executehostcommand,
        cmd: $"source '($nu.config-path)'"
      }
    }
    {
        name: fzf_change_dir
        modifier: alt
        keycode: char_c
        mode: [emacs, vi_normal, vi_insert]
        event: [
          {
              send: executehostcommand
              cmd: "
                try {
                  let result = (
                    fd --type directory
                    | fzf --preview 'eza --color=always -la {} | head -n 200'
                  )
                  cd $result
                } catch { null }"
          }
      ]
    }
    {
        name: fzf_dirs
        modifier: alt
        keycode: char_d
        mode: [emacs, vi_normal, vi_insert]
        event: [
          {
              send: executehostcommand
              cmd: "
                try {
                  let result = (
                    fd --type directory
                    | fzf --preview 'eza --color=always -la {} | head -n 200'
                  )
                  commandline edit --insert '\"'
                  commandline edit --insert $result
                  commandline edit --insert '\"'
                } catch { null }"
          }
      ]
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: [emacs, vi_insert, vi_normal]
      event: [
        {
          send: executehostcommand
          cmd: "
            let result = history
              | get command
              | str replace --all (char newline) ' '
              | uniq
              | to text
              | fzf --preview 'printf \'{}\' | nufmt --stdin o+e>| rg -v ERROR';
            commandline edit --replace $result;
            commandline set-cursor --end
          "
        }
      ]
    }
    {
      name: fuzzy_file
      modifier: control
      keycode: char_f
      mode: [emacs, vi_normal, vi_insert]
      event: [
        {
          send: executehostcommand
          cmd: "
            try {
              let result = (
                fd --type file
                | fzf --preview 'nu -l -c \"preview_file {}\"'
              )
              commandline edit --insert '\"'
              commandline edit --insert $result
              commandline edit --insert '\"'
            } catch { null }"
        }
      ]
    }
  ]
}

source aliases.nu
source load-hooks.nu

# config.nu ends here
