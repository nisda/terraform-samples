# データやオブジェクトをまとめて格納するだけのコンテナ。
# DI用に作ったが、他の用途に使ってもよい。

from typing import Any, Dict

class Container:
    _container:Dict[str,Any] = {}

    # singleton
    def __new__(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = super().__new__(cls)
        return cls._instance

    def set(self, key:str, obj:Any) -> None:
        self._container[key] = obj
        return None

    def get(self, key:str, default:Any=None) -> Any:
        return self._container.get(key, default)


