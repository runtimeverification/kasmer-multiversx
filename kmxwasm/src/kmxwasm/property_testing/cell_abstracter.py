from pyk.cterm import CTerm
from pyk.kast.inner import KInner, KSort, KVariable
from pyk.kcfg import KCFG
from pyk.kcfg.kcfg import NodeIdLike

from ..ast.generic import get_single_argument_kapply_contents_path, replace_contents_with_path


class CellAbstracter:
    def __init__(self, cell_path: list[str], variable_root: str, variable_sort: KSort, destination: NodeIdLike):
        self.__cell_path = cell_path
        self.__variable_root = variable_root
        self.__variable_sort = variable_sort
        self.__variable_index = 0
        self.__last_variable: KVariable | None = None
        self.__last_actual_value: KInner | None = None
        self.__should_be_concrete: set[NodeIdLike] = {destination}

    def abstract_node(self, kcfg: KCFG, node_id: NodeIdLike) -> None:
        node = kcfg.node(node_id)
        new_variable = KVariable(f'{self.__variable_root}_{self.__variable_index}', self.__variable_sort)
        self.__variable_index += 1

        self.__last_variable = new_variable
        self.__last_actual_value = get_single_argument_kapply_contents_path(node.cterm.config, self.__cell_path)

        self.__new_node_replace(kcfg, node, new_variable)

        if node_id in self.__should_be_concrete:
            self.__should_be_concrete.remove(node_id)

    def concretize_kcfg(self, kcfg: KCFG, with_variable: set[NodeIdLike]) -> None:
        for node in kcfg.nodes:
            if node.id in with_variable:
                continue
            if node.id in self.__should_be_concrete:
                continue
            self.__concretize_node(kcfg, node.id, allow_missing_variable=True)
        for node_id in with_variable:
            self.__concretize_node(kcfg, node_id, allow_missing_variable=False)

        self.__last_variable = None
        self.__last_actual_value = None

    def __concretize_node(self, kcfg: KCFG, node_id: NodeIdLike, allow_missing_variable: bool) -> None:
        assert self.__last_actual_value
        assert self.__last_variable

        current_node = kcfg.node(node_id)
        assert current_node
        variable = get_single_argument_kapply_contents_path(root=current_node.cterm.config, path=self.__cell_path)
        if not variable:
            raise ValueError(f'Could not find {self.__cell_path}; node_id={node_id}.')
        if not isinstance(variable, KVariable):
            if allow_missing_variable:
                self.__should_be_concrete.add(node_id)
                return
            raise ValueError(f'Expected to find a variable in {self.__cell_path}, found {variable}; node_id={node_id}.')
        if variable != self.__last_variable:
            if allow_missing_variable:
                self.__should_be_concrete.add(node_id)
                return
            raise ValueError(f'Variable {variable} not found in the generated variables dict; node_id={node_id}.')

        self.__new_node_replace(kcfg, current_node, self.__last_actual_value)
        self.__should_be_concrete.add(node_id)

    def __new_node_replace(self, kcfg: KCFG, node: KCFG.Node, contents: KInner) -> None:
        new_config = replace_contents_with_path(root=node.cterm.config, path=self.__cell_path, replacement=contents)
        new_cterm = CTerm(new_config, node.cterm.constraints)
        kcfg.replace_node(node.id, new_cterm)
