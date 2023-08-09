from pyk.kast.inner import KApply, KInner, KSequence, bottom_up


def set_single_argument_kapply_contents(root: KInner, name: str, contents: KInner) -> KInner:
    already_replaced = False

    def replace_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != name:
            return node

        nonlocal already_replaced
        assert not already_replaced
        already_replaced = True

        assert len(node.args) == 1
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
