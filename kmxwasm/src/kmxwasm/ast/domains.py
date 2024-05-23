from pyk.kast.inner import KApply, KInner, KSequence, KSort

#########
# Bytes #
#########

def int2BytesLen(length:KInner, value: KInner, endianess: KInner) -> KApply:
  return KApply('Int2Bytes(_,_,_)_BYTES-HOOKED_Bytes_Int_Int_Endianness', length, value, endianess)

def int2BytesNoLen(value: KInner, endianess: KInner, signedness:KInner) -> KApply:
  return KApply('Int2Bytes(_,_,_)_BYTES-HOOKED_Bytes_Int_Endianness_Signedness', value, endianess, signedness)

def concatBytes(first: KInner, second: KInner) -> KApply:
  return KApply('_+Bytes__BYTES-HOOKED_Bytes_Bytes_Bytes', first, second)

def lengthBytes(value: KInner) -> KApply:
  return KApply('lengthBytes(_)_BYTES-HOOKED_Int_Bytes', value)

def substrBytes(str: KInner, start: KInner, end:KInner) -> KApply:
  return KApply('substrBytes(_,_,_)_BYTES-HOOKED_Bytes_Bytes_Int_Int', str, start, end)

#######
# Int #
#######

def addInt(first: KInner, second: KInner) -> KApply:
  return KApply('_+Int_', first, second)

def subInt(first: KInner, second: KInner) -> KApply:
  return KApply('_-Int_', first, second)
