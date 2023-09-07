from pyk.kast.inner import KApply, KInner, KSequence, KVariable, bottom_up


def set_ksequence_cell_contents(root: KInner, name: str, contents: KSequence) -> KInner:
    def replace_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != name:
            return node
        assert len(node.args) == 1
        assert isinstance(node.args[0], KSequence) or isinstance(node.args[0], KVariable)
        return node.let(args=[contents])

    return bottom_up(replace_contents, root)
