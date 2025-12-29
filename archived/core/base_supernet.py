# base_supernet.py
import ipaddress

def ip_to_bin(ip):
    """将IP地址转换为32位二进制字符串"""
    return ''.join([bin(int(x)+256)[3:] for x in ip.split('.')])

def get_supernet(ips):
    """计算超网"""
    # 转换所有IP地址为二进制
    bins = [ip_to_bin(ip) for ip in ips]
    
    # 找到公共前缀
    common_prefix = ''
    for bits in zip(*bins):
        if len(set(bits)) == 1:
            common_prefix += bits[0]  # 只有一个不同的bit，保留这个bit
        else:
            break  # 如果出现不同的bit，停止
    
    # 计算前缀长度
    prefix_len = len(common_prefix)
    
    # 填充剩余的位数为0，得到完整的32位二进制
    supernet_bin = common_prefix + '0' * (32 - prefix_len)
    
    # 将二进制转换回点分十进制
    supernet_ip = '.'.join(str(int(supernet_bin[i:i+8], 2)) for i in range(0, 32, 8))
    
    return f'{supernet_ip}/{prefix_len}'

# 示例网络
# ips = ['192.168.1.0', '192.168.2.0', '192.168.3.0', '192.168.4.0']

# 计算超网
# supernet = get_supernet(ips)
# print("超网:", supernet)
