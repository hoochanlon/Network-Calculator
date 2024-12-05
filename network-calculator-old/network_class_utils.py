# network_class_utils.py
import re

# 根据CIDR位数判断网络类别
def get_network_class_by_cidr(cidr):
    # 验证CIDR格式
    validation_result = validate_cidr(cidr)
    if validation_result != "valid":
        return validation_result

    # 如果CIDR只给了位数（如 /24），则假设一个默认IP地址
    if not cidr.startswith('192.168.1.0'):
        cidr = f"192.168.1.0{cidr}"

    # 提取CIDR中的子网掩码部分（即位数）
    cidr_bits = int(cidr.split('/')[1])

    # 判断网络类别
    if 0 <= cidr_bits <= 7:
        return "Any"  # /7以下
    elif 8 <= cidr_bits <= 15:
        return "A类"  # /8 到 /15
    elif 16 <= cidr_bits <= 23:
        return "B类"  # /16 到 /23
    elif 24 <= cidr_bits <= 32:
        return "C类"  # /24 到 /32
    else:
        return "无效的CIDR"

# 验证CIDR格式
def validate_cidr(cidr):
    # 检查CIDR是否符合格式，例如：10.0.0.0/8 或 /24
    cidr_pattern = re.compile(r"^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$|^/(\d{1,2})$")
    if not cidr_pattern.match(cidr):
        return "无效的CIDR格式"
    
    # 如果是完整的CIDR，验证IP和CIDR位数是否合法
    if cidr.startswith('192.168.1.0'):
        cidr_bits = int(cidr.split('/')[1])
        if not (0 <= cidr_bits <= 32):
            return "无效的CIDR位数"
    
    return "valid"





