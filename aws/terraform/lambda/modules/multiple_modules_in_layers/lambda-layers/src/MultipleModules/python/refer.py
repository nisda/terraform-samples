# coding: utf-8

#----------------------------
# 参照するmodule
#----------------------------

# from .referenced import ReferencedClass
#   ↑
#   ↑ lambdaではこの書き方ができない。
#
#   ↓ なので、こうする。
#   ↓ 
import sys
import os
sys.path.append(os.path.dirname(__file__))     # このファイルのパスをシステムパスに追加
from referenced import ReferencedClass


def twice(value:int):
    ref_class = ReferencedClass()
    return ref_class.product(value, 2)


class ReferClass(ReferencedClass):

    def __init__(self):
        super().__init__()
    
    def squared(self, value:int):
        return self.product(value, value)

