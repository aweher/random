# Intenta loguearse en servidores ESXi dado un archivo ips.txt, un usuario y un password
# requiere pip3 install pyvmomi

from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim
import ssl
import socket
from concurrent.futures import ThreadPoolExecutor, as_completed
from collections import defaultdict

def check_esxi_port(ip):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(5)
    try:
        result = sock.connect_ex((ip, 443))
        sock.close()
        return result == 0
    except:
        sock.close()
        return False

def test_esxi_login(ip, username, password):
    try:
        if not check_esxi_port(ip):
            return ip, "no_esxi", "Puerto 443 cerrado - posiblemente no es ESXi"
            
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        context.set_ciphers('DEFAULT:@SECLEVEL=1')
        socket.setdefaulttimeout(10)
        
        si = SmartConnect(host=ip,
                         user=username,
                         pwd=password,
                         sslContext=context)
        
        if si:
            Disconnect(si)
            return ip, "success", "Conexión exitosa"
            
    except vim.fault.InvalidLogin as e:
        return ip, "failed", "Credenciales incorrectas"
    except Exception as e:
        if hasattr(e, 'msg'):
            return ip, "failed", e.msg
        return ip, "failed", str(e)

def main():
    results = defaultdict(list)
    
    with open('ips.txt', 'r') as f:
        ips = [line.strip() for line in f if line.strip()]

    username = "the_username"
    password = "the_password"
    
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(test_esxi_login, ip, username, password) 
                  for ip in ips]
        
        for future in as_completed(futures):
            ip, status, message = future.result()
            results[status].append((ip, message))

    print("\nHosts con login exitoso:")
    for ip, _ in results['success']:
        print(f"- {ip}")

    print("\nHosts con login fallido:")
    for ip, error in results['failed']:
        print(f"- {ip}: {error}")

    print("\nHosts que no son ESXi:")
    for ip, _ in results['no_esxi']:
        print(f"- {ip}")

if __name__ == "__main__":
    main()
