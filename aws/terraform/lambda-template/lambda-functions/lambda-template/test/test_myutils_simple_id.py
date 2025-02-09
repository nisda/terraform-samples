import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
from src.myutils import simple_di

def test_simple_di():
    # di_1 にセット
    di_1 = simple_di.Container()
    di_1.set("a", "AAA")

    # di_2 にも反映されている。
    di_2 = simple_di.Container()
    ret = di_2.get("a")
    assert ret == "AAA"







