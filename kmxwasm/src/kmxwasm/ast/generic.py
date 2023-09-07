from pyk.kast.inner import KApply, KInner, KSequence, bottom_up


def set_single_argument_kapply_contents(root: KInner, name: str, contents: KInner) -> KInner:
    def replace_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != name:
            return node
        assert len(node.args) == 1
        return node.let(args=[contents])

    return bottom_up(replace_contents, root)


def set_ksequence_cell_contents(root: KInner, name: str, contents: KSequence) -> KInner:
    return set_single_argument_kapply_contents(root, name, contents)
