#!/usr/bin/env python3
from pyngrok.conf import PyngrokConfig
from pyngrok import ngrok
import subprocess
import os

def log_ngrok(log):
  print(f"NGROK: {str(log)}")

def main():
  pyngrok_config = PyngrokConfig(log_event_callback=log_ngrok, region="eu")
  connect_url = ngrok.connect(8088, "http", pyngrok_config=pyngrok_config)
  https_url = f"https{connect_url[4:]}"
  ngrok_process = ngrok.get_ngrok_process()
  docker_compose_env = os.environ.copy()
  docker_compose_env["IRMA_URL"] = https_url
  docker_compose_env["BALIE_CLIENT_FRONTENDADDRESS"] = "http://localhost:8081"
  proc = subprocess.Popen(["docker-compose", "up"], env=docker_compose_env)
  print(f"Using ngrok url for IRMA_URL: {https_url}")

  try:
    proc.communicate()
    ngrok_process.proc.wait()
  except KeyboardInterrupt:
    print("Shutting down...")
    ngrok.kill()
    proc.wait()

if __name__ == "__main__":
    main()
