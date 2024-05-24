from pyk.kast.inner import KApply, KInner

#########
# Bytes #
#########


def int2BytesLen(length: KInner, value: KInner, endianess: KInner) -> KApply:  # noqa: N802
    return KApply('Int2Bytes(_,_,_)_BYTES-HOOKED_Bytes_Int_Int_Endianness', length, value, endianess)


def int2BytesNoLen(value: KInner, endianess: KInner, signedness: KInner) -> KApply:  # noqa: N802
    return KApply('Int2Bytes(_,_,_)_BYTES-HOOKED_Bytes_Int_Endianness_Signedness', value, endianess, signedness)


def concatBytes(first: KInner, second: KInner) -> KApply:  # noqa: N802
    return KApply('_+Bytes__BYTES-HOOKED_Bytes_Bytes_Bytes', first, second)


def lengthBytes(value: KInner) -> KApply:  # noqa: N802
    return KApply('lengthBytes(_)_BYTES-HOOKED_Int_Bytes', value)


def substrBytes(str: KInner, start: KInner, end: KInner) -> KApply:  # noqa: N802
    return KApply('substrBytes(_,_,_)_BYTES-HOOKED_Bytes_Bytes_Int_Int', str, start, end)


def unsignedBytes() -> KApply:  # noqa: N802
    return KApply('unsignedBytes')


#######
# Int #
#######


def addInt(first: KInner, second: KInner) -> KApply:  # noqa: N802
    return KApply('_+Int_', first, second)


def subInt(first: KInner, second: KInner) -> KApply:  # noqa: N802
    return KApply('_-Int_', first, second)
