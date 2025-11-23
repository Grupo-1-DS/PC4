from fastapi import FastAPI
import os
import getpass
import uvicorn

app = FastAPI(
    title="Non-root everywhere lab"
)

@app.get("/whoami")
def who_am_i():
    return {"uid": os.getuid(), "gid": os.getgid(), "user": getpass.getuser()}

@app.get("/write-file")
def write_file():
    try:
        path = "/restricted/test.txt"
        with open(path, "w") as f:
            f.write("Contenido de prueba")
        return {"message": f"Archivo escrito con éxito en {path}"}
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    print(f"Username is {getpass.getuser()}, UID is {os.getuid()}, GID is {os.getgid()}")
    uvicorn.run(app, host="0.0.0.0", port=8000)