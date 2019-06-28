import sys
import psutil

for proc in psutil.process_iter():
        if proc.name() == sys.argv[1]:
            proc.kill()
