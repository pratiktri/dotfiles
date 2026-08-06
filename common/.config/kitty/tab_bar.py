# common/.config/kitty/tab_bar.py
"""Custom kitty tab bar with zoom indicator for stack layout.

Requires in kitty.conf::

    tab_bar_style custom

When a tab is in the 'stack' layout (e.g. after pressing kitty_mod+z
to zoom a split), a magnifying-glass icon is shown at the start of
that tab's title on the tab bar.
"""

from __future__ import annotations

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    draw_tab_with_slant,
    draw_title,
)

ZOOM_ICON = " "

# Use the built-in slant renderer if it's available; fall back to
# a plain title draw otherwise (should never happen on recent kitty).
try:
    _render = draw_tab_with_slant
except NameError:  # pragma: no cover
    _render = draw_title


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: str,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # kitty_mod+z -> toggle_layout stack.
    # Stack layout means one window fills the whole tab = "zoomed".
    if getattr(tab, "layout_name", "") == "stack":
        # Inject the icon into the title so the built-in renderer draws
        # it *inside* the tab, before the trailing slant separator.
        tab = tab._replace(title=f"{ZOOM_ICON}{tab.title}")

    return _render(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
