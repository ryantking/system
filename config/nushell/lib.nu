# lib.nu: Library functions

# Show a file preview, supports images
export def preview_file [file] {
    let file_type = (file --mime-type -b $file)
    if ($file_type | str starts-with "image/") {
        timg -g 80x80 $file
    } else {
        bat --style=numbers --color=always --line-range :500 $file
    }
}

# Convert a relative path to an absolute path
# Can pass through stdin or as an argument.
export def init-path [path?: path] {
  let p = (if ($in != null) { $in } else { $path })
  let parent = $p | path dirname
  if not ($parent | path exists) {
    mkdir $parent
  }
  $p
}

# lib.nu ends here
