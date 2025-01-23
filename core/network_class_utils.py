# network_class_utils.py
import re
import ipaddress

# 根据CIDR位数和地址判断网络类别
def get_network_class_by_cidr(cidr):
    print(cidr)
    # 验证CIDR格式
    validation_result = validate_cidr(cidr)
    print(f"CIDR验证结果: {validation_result}")  # 打印验证结果
    if validation_result != "valid":
        return validation_result

    # 处理CIDR格式，确保IP是网络地址而不是主机地址
    if '/' in cidr:
        ip, prefix = cidr.split('/')
        print(f"IP地址: {ip}, 子网掩码位数: {prefix}")  # 打印拆分后的IP地址和子网掩码位数
        network = ipaddress.IPv4Network(f"{ip}/{prefix}", strict=False)
    else:
        print(f"没有子网掩码，默认使用 /16 位数")
        network = ipaddress.IPv4Network(f"{cidr}/16", strict=False)  # 默认 /16

    # 输出网络地址信息
    print(f"网络地址: {network.network_address}, 网络范围: {network}")  # 打印网络地址

    # 判断IP地址所在类别
    ip = str(network.network_address)
    print(f"判断的IP: {ip}")

    if ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("10.0.0.0/8"):
        return "A类（私有）"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("172.16.0.0/12"):
        return "B类（私有）"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("192.168.0.0/16"):
        return "C类（私有）"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("127.0.0.0/8"):
        return "Localhost"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("169.254.0.0/16"):
        return "ZeroConf (Apipa/Bonjour)"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("100.64.0.0/10"):
        return "Internal routing (RFC 6598)"
    
    # 判断A、B、C、D、E类
    if ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("0.0.0.0/8"):
        return "A类"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("128.0.0.0/8"):
        return "B类"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("192.0.0.0/8"):
        return "C类"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("224.0.0.0/4"):
        return "D类"
    elif ipaddress.IPv4Address(ip) in ipaddress.IPv4Network("240.0.0.0/4"):
        return "E类"

    return "无效的CIDR范围"

# 验证CIDR格式
def validate_cidr(cidr):
    # 检查CIDR是否符合格式，例如：10.0.0.0/8 或 /24
    # 改进的正则表达式，确保匹配完整的IP地址（0-255）
    cidr_pattern = re.compile(r"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/([0-9]|[1-2][0-9]|3[0-2])$")
    if not cidr_pattern.match(cidr):
        return "无效的CIDR格式"

    # 如果是完整的CIDR，验证IP和CIDR位数是否合法
    if '/' in cidr:
        ip, cidr_bits = cidr.split('/')
        cidr_bits = int(cidr_bits)
        if not (0 <= cidr_bits <= 32):
            return "无效的CIDR位数"
    
    return "valid"
