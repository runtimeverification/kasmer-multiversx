from dataclasses import dataclass

from pyk.kast.inner import KApply, KInner, KSequence, bottom_up


def get_single_argument_kapply_contents(root: KInner, name: str) -> KInner | None:
    result: KInner | None = None

    def find_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != name:
            return node

        nonlocal result
        if result:
            raise ValueError(f'Expected at most one node named {name}, found more.')
        if len(node.args) != 1:
            raise ValueError(f'Expected node {name} to heve exactly 1 child, found {len(node.args)}.')
        result = node.args[0]
        return node

    bottom_up(find_contents, root)
    return result


def set_single_argument_kapply_contents(root: KInner, name: str, contents: KInner) -> KInner:
    already_replaced = False

    def replace_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != name:
            return node

        nonlocal already_replaced
        if already_replaced:
            raise ValueError(f'Expected at most one node named {name}, found more.')
        already_replaced = True

        if len(node.args) != 1:
            raise ValueError(f'Expected node {name} to heve exactly 1 child, found {len(node.args)}.')
        return node.let(args=[contents])

    return bottom_up(replace_contents, root)


def set_ksequence_cell_contents(root: KInner, name: str, contents: KSequence) -> KInner:
    return set_single_argument_kapply_contents(root, name, contents)


def replace_with_path(root: KInner, path: list[str], replacement: KInner) -> KInner:
    assert path
    assert isinstance(root, KApply)
    assert root.args
    had_match = False
    new_args = []
    for arg in root.args:
        if not isinstance(arg, KApply):
            new_args.append(arg)
            continue
        if not arg.label.name == path[0]:
            new_args.append(arg)
            continue
        if had_match:
            raise ValueError(f'Path component found twice: {path[0]!r}')
        assert not had_match
        had_match = True
        if len(path) > 1:
            new_args.append(replace_with_path(arg, path[1:], replacement))
        else:
            new_args.append(replacement)
    if not had_match:
        raise ValueError(f'Path component not found: {path[0]!r}')
    return root.let(args=new_args)


def replace_contents_with_path(root: KInner, path: list[str], replacement: KInner) -> KInner:
    assert path
    assert isinstance(root, KApply)
    assert root.args
    had_match = False
    new_args = []
    for arg in root.args:
        if not isinstance(arg, KApply):
            new_args.append(arg)
            continue
        if not arg.label.name == path[0]:
            new_args.append(arg)
            continue
        if had_match:
            raise ValueError(f'Path component found twice: {path[0]!r}')
        assert not had_match
        had_match = True
        if len(path) > 1:
            new_args.append(replace_contents_with_path(arg, path[1:], replacement))
        else:
            if not arg.arity == 1:
                raise ValueError(f'Expected {path[0]!r} to have exactly one child, got {arg.arity}.')
            new_args.append(arg.let(args=[replacement]))
    if not had_match:
        raise ValueError(f'Path component not found: {path[0]!r}')
    return root.let(args=new_args)


@dataclass(frozen=True)
class ComponentNotFound:
    element: str


def find_with_path_internal(root: KInner, path: list[str]) -> KInner | ComponentNotFound:
    assert path
    for element in path:
        assert isinstance(root, KApply)
        assert root.args
        found_arg: KInner | None = None
        for arg in root.args:
            if not isinstance(arg, KApply):
                continue
            if not arg.label.name == element:
                continue
            if found_arg:
                raise ValueError(f'Path component found twice: {element!r}')
            found_arg = arg
        if not found_arg:
            return ComponentNotFound(element)
        root = found_arg
    return root


def get_with_path(root: KInner, path: list[str]) -> KInner:
    result = find_with_path_internal(root, path)
    if isinstance(result, ComponentNotFound):
        raise ValueError(f'Path component not found: {result.element!r}')
    return result


def find_with_path(root: KInner, path: list[str]) -> KInner | None:
    result = find_with_path_internal(root, path)
    if isinstance(result, ComponentNotFound):
        return None
    return result


def get_single_argument_kapply_contents_path(root: KInner, path: list[str]) -> KInner:
    node = get_with_path(root, path)
    if not isinstance(node, KApply):
        raise ValueError(f'Expected KApply for {path}')
    if node.arity != 1:
        raise ValueError(f'Expected {path} to have exactly one child, got {node.arity}.')
    return node.args[0]
