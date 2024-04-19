from collections.abc import Callable

from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KSort, KVariable, bottom_up
from pyk.kcfg import KCFG
from pyk.kcfg.kcfg import NodeIdLike

from ..ast.generic import get_single_argument_kapply_contents_path, replace_contents_with_path


class CellAbstracter:
    def __init__(
        self,
        variable_root: str,
        variable_sort: KSort,
        destination: NodeIdLike,
        replace_with_variable: Callable[[KInner, dict[KVariable, KInner], Callable[[], KVariable]], KInner],
        replace_with_original: Callable[[KInner, dict[KVariable, KInner], bool], KInner],
    ):
        self.__variable_root = variable_root
        self.__variable_sort = variable_sort
        self.__variable_index = 0
        self.__variable_to_value: dict[KVariable, KInner] = {}
        self.__should_be_concrete: set[NodeIdLike] = {destination}
        self.__replace_with_variable = replace_with_variable
        self.__replace_with_original = replace_with_original

    def abstract_node(self, kcfg: KCFG, node_id: NodeIdLike) -> None:
        assert (
            not self.__variable_to_value
        )  # Not strictly needed, but users should call reset after finishing with the previous node.

        node = kcfg.node(node_id)

        new_config = self.__replace_with_variable(node.cterm.config, self.__variable_to_value, self.__next_variable)
        new_cterm = CTerm(new_config, node.cterm.constraints)
        kcfg.replace_node(KCFG.Node(node.id, new_cterm))

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
        self.__variable_to_value = {}

    def __next_variable(self) -> KVariable:
        new_variable = KVariable(f'{self.__variable_root}_{self.__variable_index}', self.__variable_sort)
        self.__variable_index += 1
        return new_variable

    def __concretize_node(self, kcfg: KCFG, node_id: NodeIdLike, allow_missing_variable: bool) -> None:
        variable_to_value = dict(self.__variable_to_value)

        node = kcfg.node(node_id)

        new_config = self.__replace_with_original(node.cterm.config, variable_to_value, allow_missing_variable)
        new_cterm = CTerm(new_config, node.cterm.constraints)
        kcfg.replace_node(KCFG.Node(node.id, new_cterm))

        self.__should_be_concrete.add(node_id)


def multi_cell_abstracter(
    parent_path: list[str], cell_name: str, variable_root: str, variable_sort: KSort, destination: NodeIdLike
) -> CellAbstracter:
    def replace_with_variable(
        config: KInner, variable_to_value: dict[KVariable, KInner], new_variable: Callable[[], KVariable]
    ) -> KInner:
        def replace(term: KInner) -> KInner:
            if not isinstance(term, KApply):
                return term
            if not term.label.name == cell_name:
                return term
            if not term.arity == 1:
                raise ValueError(f'Wrong arity for {cell_name}: {term.arity}')

            variable = new_variable()
            variable_to_value[variable] = term.args[0]

            return term.let(args=[variable])

        parent = get_single_argument_kapply_contents_path(config, parent_path)
        new_parent = bottom_up(replace, parent)
        return replace_contents_with_path(root=config, path=parent_path, replacement=new_parent)

    def replace_with_original(
        config: KInner, variable_to_value: dict[KVariable, KInner], allow_missing_variable: bool
    ) -> KInner:
        def replace(term: KInner) -> KInner:
            if not isinstance(term, KApply):
                return term
            if not term.label.name == cell_name:
                return term
            if not term.arity == 1:
                raise ValueError(f'Wrong arity for {cell_name}: {term.arity}')
            arg = term.args[0]
            if not isinstance(arg, KVariable):
                if allow_missing_variable:
                    return term
                raise ValueError(f'Expected to find a variable in {cell_name}, found {arg}.')
            nonlocal variable_to_value
            if arg not in variable_to_value:
                if allow_missing_variable:
                    return term
                raise ValueError(f'Variable {arg} not found in the generated variables dict.')

            original = variable_to_value[arg]
            del variable_to_value[arg]

            return term.let(args=[original])

        parent = get_single_argument_kapply_contents_path(config, parent_path)
        new_parent = bottom_up(replace, parent)
        return replace_contents_with_path(root=config, path=parent_path, replacement=new_parent)

    return CellAbstracter(
        variable_root=variable_root,
        variable_sort=variable_sort,
        destination=destination,
        replace_with_variable=replace_with_variable,
        replace_with_original=replace_with_original,
    )


def single_cell_abstracter(
    cell_path: list[str], variable_root: str, variable_sort: KSort, destination: NodeIdLike
) -> CellAbstracter:
    def replace_with_variable(
        config: KInner, variable_to_value: dict[KVariable, KInner], new_variable: Callable[[], KVariable]
    ) -> KInner:
        variable = new_variable()
        original = get_single_argument_kapply_contents_path(config, cell_path)
        variable_to_value[variable] = original
        return replace_contents_with_path(root=config, path=cell_path, replacement=variable)

    def replace_with_original(
        config: KInner, variable_to_value: dict[KVariable, KInner], allow_missing_variable: bool
    ) -> KInner:
        variable = get_single_argument_kapply_contents_path(root=config, path=cell_path)
        if not variable:
            raise ValueError(f'Could not find {cell_path}.')
        if not isinstance(variable, KVariable):
            if allow_missing_variable:
                return config
            raise ValueError(f'Expected to find a variable in {cell_path}, found {variable}.')
        if variable not in variable_to_value:
            if allow_missing_variable:
                return config
            raise ValueError(f'Variable {variable} not found in the generated variables dict.')
        original = variable_to_value[variable]
        del variable_to_value[variable]

        return replace_contents_with_path(root=config, path=cell_path, replacement=original)

    return CellAbstracter(
        variable_root=variable_root,
        variable_sort=variable_sort,
        destination=destination,
        replace_with_variable=replace_with_variable,
        replace_with_original=replace_with_original,
    )
