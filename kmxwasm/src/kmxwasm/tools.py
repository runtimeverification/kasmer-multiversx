from pathlib import Path
from typing import Any, Optional

from pyk.kcfg.explore import KCFGExplore
from pyk.kore.rpc import KoreClient, KoreServer
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve


class Tools:
    def __init__(self, definition_dir: Path) -> None:
        self.__definition_dir = definition_dir
        self.__kprove: Optional[KProve] = None
        self.__explorer: Optional[KCFGExplore] = None
        self.__kore_server: Optional[KoreServer] = None
        self.__kore_client: Optional[KoreClient] = None

    def __enter__(self) -> 'Tools':
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()

    def close(self) -> None:
        if self.__kore_client:
            self.__kore_client.close()
        if self.__kore_server:
            self.__kore_server.close()

    @property
    def kprove(self) -> KProve:
        if not self.__kprove:
            self.__kprove = KProve(self.__definition_dir)
        return self.__kprove

    @property
    def printer(self) -> KPrint:
        return self.kprove

    @property
    def explorer(self) -> KCFGExplore:
        if not self.__kore_server:
            if self.__kore_client:
                raise RuntimeError('Non-null KoreClient with null KoreServer.')
            self.__kore_server = KoreServer(self.__definition_dir, self.printer.main_module)
        if not self.__kore_client:
            self.__kore_client = KoreClient('localhost', self.__kore_server.port)

        if not self.__explorer:
            self.__explorer = KCFGExplore(self.printer, self.__kore_client)
        return self.__explorer
