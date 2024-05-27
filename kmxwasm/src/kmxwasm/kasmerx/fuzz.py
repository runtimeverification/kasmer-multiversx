from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .utils import KasmerxProject


def kasmerx_fuzz(project: KasmerxProject) -> None: ...
