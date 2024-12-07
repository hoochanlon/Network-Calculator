# subnet_utils.py
import ipaddress
import math
import re

# 根据主机数计算子网掩码相关信息
def hosts_to_subnet_mask_and_hosts(hosts):
    if hosts < 2:
        return "主机数至少为2，不能为0或1"
    
    bits_needed = math.ceil(math.log2(hosts + 2))  # 主机数 + 2 是网络地址和广播地址
    subnet_mask_bits = 32 - bits_needed  # 子网掩码的位数

    # 使用 ipaddress 计算子网掩码
    network = ipaddress.IPv4Network(f"0.0.0.0/{subnet_mask_bits}", strict=False)
    subnet_mask = str(network.netmask)

    # 生成CIDR
    cidr = f"/{subnet_mask_bits}"

    # 计算可用主机数
    usable_hosts = (2 ** (32 - subnet_mask_bits)) - 2

    # 计算反掩码
    inverted_mask = str(ipaddress.IPv4Address((0xFFFFFFFF >> subnet_mask_bits) & 0xFFFFFFFF))

    # 子网掩码的二进制表示
    subnet_mask_binary = '.'.join(f"{int(octet):08b}" for octet in subnet_mask.split('.'))

    # 反掩码的二进制表示
    inverted_mask_binary = '.'.join(f"{int(octet):08b}" for octet in inverted_mask.split('.'))

    # 子网掩码的十六进制表示
    subnet_mask_hex = ''.join(f"{int(octet):02X}" for octet in subnet_mask.split('.'))

    # 反掩码的十六进制表示
    inverted_mask_hex = ''.join(f"{int(octet):02X}" for octet in inverted_mask.split('.'))


    return (
            hosts,
            subnet_mask,
            cidr,
            usable_hosts,
            inverted_mask,
            subnet_mask_binary,
            inverted_mask_binary,
            subnet_mask_hex,
            inverted_mask_hex
        )


# 根据CIDR或子网掩码计算相关信息
def cidr_or_subnet_mask_to_info(cidr_or_mask):
    # 如果输入的是CIDR
    try:
        if '/' in cidr_or_mask:
            network = ipaddress.IPv4Network(f"0.0.0.0{cidr_or_mask}", strict=False)
            subnet_mask = str(network.netmask)
            subnet_mask_bits = network.prefixlen
        else:
            # 输入的是子网掩码
            subnet_mask = cidr_or_mask
            subnet_mask_bits = sum([bin(int(octet)).count('1') for octet in subnet_mask.split('.')])

        # 计算CIDR
        cidr = f"/{subnet_mask_bits}"

        # 计算可用主机数
        usable_hosts = (2 ** (32 - subnet_mask_bits)) - 2

        # 计算反掩码
        inverted_mask = str(ipaddress.IPv4Address((0xFFFFFFFF >> subnet_mask_bits) & 0xFFFFFFFF))

        # 子网掩码的二进制表示
        subnet_mask_binary = '.'.join(f"{int(octet):08b}" for octet in subnet_mask.split('.'))

        # 反掩码的二进制表示
        inverted_mask_binary = '.'.join(f"{int(octet):08b}" for octet in inverted_mask.split('.'))

        # 子网掩码的十六进制表示
        subnet_mask_hex = '.'.join(f"{int(octet):02X}" for octet in subnet_mask.split('.'))

        # 反掩码的十六进制表示
        inverted_mask_hex = '.'.join(f"{int(octet):02X}" for octet in inverted_mask.split('.'))


        # 多行返回 
        return (
            cidr_or_mask,
            subnet_mask,
            cidr,
            usable_hosts,
            inverted_mask,
            subnet_mask_binary,
            inverted_mask_binary,
            subnet_mask_hex,
            inverted_mask_hex
        )

    except ValueError:
        return "输入的CIDR或子网掩码无效"

def validate_subnet_mask(mask):
    """
    验证子网掩码是否为有效的格式。
    :param mask: 子网掩码字符串
    :return: True 如果子网掩码有效, 否则返回 False
    """
    # 检查子网掩码格式
    if re.match(r"^(255|254|252|248|240|224|192|128|0)\.((255|254|252|248|240|224|192|128|0)\.){2}(255|254|252|248|240|224|192|128|0)$", mask):
        # 确保子网掩码是连续的，例如 255.255.255.0 是有效，但 255.0.255.0 无效
        parts = list(map(int, mask.split('.')))
        binary_str = ''.join(f"{part:08b}" for part in parts)
        return '01' not in binary_str  # 检查二进制表示中是否有不连续的 0 和 1
    return False

def validate_cidr(cidr):
    """
    验证CIDR是否为有效格式，例如 /0 到 /32。
    :param cidr: CIDR字符串
    :return: True 如果CIDR有效, 否则返回 False
    """
    if cidr.startswith('/'):
        try:
            cidr_value = int(cidr[1:])
            return 0 <= cidr_value <= 32
        except ValueError:
            return False
    return False