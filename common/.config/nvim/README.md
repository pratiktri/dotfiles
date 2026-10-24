# Neovim

Neovim config, and a reference for resolving git merge conflicts in Neovim.

## Merge conflicts

`./../../.gitconfig` sets `nvimdiff` as both `diff.tool` and `merge.tool`.
There are 2 ways to resolve conflicts:

- **`git mergetool`**: git opens each conflicted file in a 4-window diff, one file at a time.
- **diffview.nvim**: `:DiffviewOpen` lists every conflicted file in one view, with keymaps to pick a side per conflict.

### git mergetool

`git mergetool` asks before opening each file (`mergetool.prompt = true`).
The default layout is `(LOCAL,BASE,REMOTE)/MERGED`:

```
┌───────┬──────┬────────┐
│ LOCAL │ BASE │ REMOTE │
├───────┴──────┴────────┤
│        MERGED         │
└───────────────────────┘
```

| Window | Content |
| --- | --- |
| LOCAL | Current branch version ("ours") |
| BASE | Common ancestor of both versions |
| REMOTE | Version being merged in ("theirs") |
| MERGED | Working file with conflict markers. Only this file is saved. |

During a rebase, the sides swap: LOCAL is the branch being rebased onto, REMOTE is the commit being replayed.

Commands, run with the cursor in MERGED:

| Command | Action |
| --- | --- |
| `]c` / `[c` | Jump to next / previous change |
| `:diffget LO` | Take the LOCAL version of the hunk under the cursor |
| `:diffget RE` | Take the REMOTE version |
| `:diffget BA` | Take the BASE version |
| `:diffupdate` | Recompute the diff after editing by hand |
| `:wqa` | Save and mark the file resolved |
| `:cq` | Quit with an error: git keeps the file unresolved and moves to the next one |

`:diffget` copies a whole hunk.
To keep lines from both sides, take one side, then edit the rest in by hand.

Other layouts are set with `mergetool.nvimdiff.layout`, or picked per run with `git mergetool -t <tool>`:

| Tool / layout | Windows |
| --- | --- |
| `nvimdiff1` | LOCAL and REMOTE only. LOCAL is saved as the result. |
| `nvimdiff2` | `LOCAL,MERGED,REMOTE` in 3 columns |
| `nvimdiff3` | MERGED only |

`git difftool` uses the same tool: LOCAL and REMOTE side by side, read-only.

### diffview.nvim

[diffview.nvim](https://github.com/sindrets/diffview.nvim) is installed as a dependency of neogit.
`:DiffviewOpen` during a merge or rebase lists the conflicted files and opens each in a 3-way view.

| Key | Action |
| --- | --- |
| `]x` / `[x` | Jump to next / previous conflict |
| `<leader>co` | Choose ours |
| `<leader>ct` | Choose theirs |
| `<leader>cb` | Choose base |
| `<leader>ca` | Choose all versions |
| `dx` | Delete the conflict region |
| `<leader>cO`, `cT`, `cB`, `cA`, `dX` | Same as above, for every conflict in the file |
| `:DiffviewClose` | Close the view |

Resolved files still need `git add`.

### Finishing or aborting

| Command | Action |
| --- | --- |
| `git checkout --ours <file>` / `--theirs <file>` | Take one side for the whole file, without opening a tool |
| `git merge --continue` / `git rebase --continue` | Commit the resolution once every file is staged |
| `git merge --abort` / `git rebase --abort` | Drop the merge and restore the branch as it was |
