import time


class Timer:
    def __init__(self, message: str) -> None:
        self.__message = message
        self.__start = time.time()

    def measure(self) -> float:
        duration = time.time() - self.__start
        print(self.__message, duration, 'sec.', flush=True)
        return duration
