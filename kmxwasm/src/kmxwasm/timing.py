import time


class Timer:
    def __init__(self, message: str) -> None:
        self.__message = message
        self.__start = time.time()

    def measure(self) -> None:
        print(self.__message, time.time() - self.__start, 'sec.', flush=True)
