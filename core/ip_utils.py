# ip_utils.py
import sys
import os
'''
将当前脚本所在的目录（即 __file__ 所在的目录）添加到 Python 的模块搜索路径 (sys.path) 中。
这是通过使用 os.path 模块来构建当前脚本路径的绝对路径并将其添加到 sys.path 列表。
'''
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '.')))
print(sys.path)
import ipaddress
import re
from core.network_class_utils import get_network_class_by_cidr

# 根据IP地址和子网掩码计算网络和IP信息
def calculate_ip_info(ip_address, subnet_mask):
    try:
        # 检查CIDR是否在合理范围内
        if '/' in subnet_mask:
            cidr_bits = int(subnet_mask.strip('/'))
            if not (0 <= cidr_bits <= 32):  # /0 到 /32
                return "无效的CIDR位数，必须在/0到/32之间"

        # 创建网络对象
        network = ipaddress.IPv4Network(f"{ip_address}/{subnet_mask}", strict=False)

        # 网络信息
        network_address = network.network_address
        broadcast_address = network.broadcast_address
        cidr = f"/{network.prefixlen}"

        # 可用IP数量（减去网络地址和广播地址）
        usable_ips = network.num_addresses - 2

        # 懒计算：第一可用IP和最后可用IP，不生成所有主机
        first_usable_ip = None
        last_usable_ip = None
        if usable_ips > 0:
            # 第一可用IP
            first_usable_ip = ipaddress.IPv4Address(network.network_address + 1)
            # 最后可用IP
            last_usable_ip = ipaddress.IPv4Address(network.broadcast_address - 1)

        # IP地址和子网掩码的二进制表示
        ip_binary = '.'.join(f"{int(octet):08b}" for octet in ip_address.split('.'))
        subnet_mask_binary = '.'.join(f"{int(octet):08b}" for octet in subnet_mask.split('.'))

        # 获取IP地址和子网掩码的十进制与十六进制表示
        ip_decimal = str(ipaddress.IPv4Address(ip_address))
        subnet_mask_decimal = str(ipaddress.IPv4Address(subnet_mask))
        ip_hexadecimal = f"{int(ip_address.split('.')[0]):02X}{int(ip_address.split('.')[1]):02X}{int(ip_address.split('.')[2]):02X}{int(ip_address.split('.')[3]):02X}"
        subnet_mask_hexadecimal = f"{int(subnet_mask.split('.')[0]):02X}{int(subnet_mask.split('.')[1]):02X}{int(subnet_mask.split('.')[2]):02X}{int(subnet_mask.split('.')[3]):02X}"

        # 计算逆IP和反掩码
        reverse_ip = str(ipaddress.IPv4Address(int(ipaddress.IPv4Address(ip_address)) ^ 0xFFFFFFFF))
        reverse_subnet_mask = str(ipaddress.IPv4Address(int(ipaddress.IPv4Address(subnet_mask)) ^ 0xFFFFFFFF))

        # 网络类别
        network_class = get_network_class_by_cidr(f"{ip_address}{cidr}")

        # 总IP数量的计算方法
        total_ips = 2 ** (32 - network.prefixlen)

        return {
            "cidr": cidr,
            "network_address": str(network_address),
            "broadcast_address": str(broadcast_address),
            "usable_ips": usable_ips,
            "first_usable_ip": str(first_usable_ip) if first_usable_ip else "无",
            "last_usable_ip": str(last_usable_ip) if last_usable_ip else "无",
            "ip_binary": ip_binary,
            "subnet_mask_binary": subnet_mask_binary,
            "ip_decimal": ip_decimal,
            "subnet_mask_decimal": subnet_mask_decimal,
            "ip_hexadecimal": ip_hexadecimal,
            "subnet_mask_hexadecimal": subnet_mask_hexadecimal,
            "reverse_ip": reverse_ip,
            "reverse_subnet_mask": reverse_subnet_mask,
            "network_class": network_class,
            "total_ips": total_ips  # 显示总IP数量
        }
    except ValueError as e:
        return str(e)

# 根据CIDR计算子网掩码
def cidr_to_subnet_mask(cidr):
    try:
        # 提取CIDR的位数
        cidr_bits = int(cidr.strip('/'))
        subnet_mask = (0xFFFFFFFF << (32 - cidr_bits)) & 0xFFFFFFFF
        return str(ipaddress.IPv4Address(subnet_mask))
    except ValueError:
        return "无效的CIDR，注意检查格式"

# 验证IP和子网掩码的格式
def validate_ip_and_mask(ip_address, subnet_mask):
    ip_pattern = re.compile(r"^(?:\d{1,3}\.){3}\d{1,3}$")
    # 验证IP地址格式
    if not ip_pattern.match(ip_address):
        return "无效的IP地址，注意检查格式"
    
    # 如果是CIDR格式，则验证CIDR
    if subnet_mask.startswith('/'):
        try:
            int(subnet_mask.strip('/'))
            return "valid"
        except ValueError:
            return "无效的CIDR，注意检查格式"
    
    # 验证子网掩码格式
    subnet_mask_parts = subnet_mask.split('.')
    if len(subnet_mask_parts) != 4:
        return "无效的子网掩码，注意检查格式"
    
    for part in subnet_mask_parts:
        if not part.isdigit() or not (0 <= int(part) <= 255):
            return "无效的子网掩码，注意检查格式"
    
    return "valid"
