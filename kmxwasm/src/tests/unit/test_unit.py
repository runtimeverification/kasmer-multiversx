from pathlib import Path

import pytest
from pyk.utils import abs_or_rel_to

from kmxwasm.kasmer.utils import read_contract_target

TEST_DATA = (
    (
        'string-single-contract',
        '../../deps/mx-sdk-rs/contracts/examples/adder',
        '../../deps/mx-sdk-rs/contracts/examples/adder',
        None,
    ),
    (
        'dict-single-contract',
        {
            'path': '../../deps/mx-sdk-rs/contracts/examples/adder',
        },
        '../../deps/mx-sdk-rs/contracts/examples/adder',
        None,
    ),
    (
        'dict-multi-contract',
        {
            'path': '../../deps/mx-sdk-rs/contracts/examples/multisig',
            'name': 'multisig-full',
        },
        '../../deps/mx-sdk-rs/contracts/examples/multisig',
        'multisig-full',
    ),
)


@pytest.mark.parametrize(('id', 'input', 'directory', 'name'), TEST_DATA, ids=[td[0] for td in TEST_DATA])
def test_read_contract_target(id: str, input: str | dict, directory: str, name: str) -> None:

    # Given
    project_dir = Path('a/b/c')

    # When
    actual = read_contract_target(project_dir, input)

    # Then
    actual_path = actual.directory.resolve()
    expected_path = abs_or_rel_to(Path(directory), base=project_dir).resolve()
    assert actual_path == expected_path
    assert actual.name == name
