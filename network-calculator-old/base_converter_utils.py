def convert_ip(ip_input):
    try:
        # 去掉空格并将输入转换为大写（便于十六进制处理）
        ip_input = ip_input.strip().upper()

        # 如果输入是没有点分隔符的32位二进制字符串
        if len(ip_input) == 32 and all(c in '01' for c in ip_input):
            # 自动将其分隔为点分二进制格式
            ip_input = '.'.join([ip_input[i:i+8] for i in range(0, 32, 8)])

        # 分割为点分部分
        ip_parts = ip_input.split('.')

        if len(ip_parts) == 4:
            # 判断是否为点分二进制格式
            if all(len(part) == 8 and all(c in '01' for c in part) for part in ip_parts):
                ip_decimal = '.'.join(str(int(part, 2)) for part in ip_parts)
                ip_decimal_no_dot = sum(int(part, 2) << (8 * (3 - i)) for i, part in enumerate(ip_parts))
                ip_hex = ''.join(format(int(part, 2), '02X') for part in ip_parts)  # 无点分十六进制
                # 计算反码
                complement_binary = '.'.join(''.join('1' if c == '0' else '0' for c in part) for part in ip_parts)
                complement_decimal = '.'.join(str(int(part, 2) ^ 255) for part in ip_parts)
                complement_decimal_no_dot = 4294967295 - ip_decimal_no_dot
                complement_hex = ''.join(format(int(part, 2) ^ 255, '02X') for part in ip_parts)  # 无点分十六进制
                return (
                    f"二进制: {ip_input}\n"
                    f"十进制: {ip_decimal}\n"
                    f"无点分十进制: {ip_decimal_no_dot}\n"
                    f"十六进制: {ip_hex}\n\n"
                    f"反码（十进制）:\n{complement_decimal}\n"
                    f"反码（二进制）:\n{complement_binary}\n"
                    f"反码（无点分十进制）: {complement_decimal_no_dot}\n"
                    f"反码（十六进制）: {complement_hex}"
                )

            # 判断是否为点分十进制格式
            elif all(part.isdigit() and 0 <= int(part) <= 255 for part in ip_parts):
                ip_binary = '.'.join(format(int(part), '08b') for part in ip_parts)
                ip_decimal_no_dot = sum(int(part) << (8 * (3 - i)) for i, part in enumerate(ip_parts))
                ip_hex = ''.join(format(int(part), '02X') for part in ip_parts)  # 无点分十六进制
                # 计算反码
                complement_binary = '.'.join(format(255 - int(part), '08b') for part in ip_parts)
                complement_decimal = '.'.join(str(255 - int(part)) for part in ip_parts)
                complement_decimal_no_dot = 4294967295 - ip_decimal_no_dot
                complement_hex = ''.join(format(255 - int(part), '02X') for part in ip_parts)  # 无点分十六进制
                return (
                    f"十进制: {ip_input}\n"
                    f"无点分十进制: {ip_decimal_no_dot}\n"
                    f"二进制: {ip_binary}\n"
                    f"十六进制: {ip_hex}\n\n"
                    f"反码（二进制）:\n{complement_binary}\n"
                    f"反码（十进制）: {complement_decimal}\n"
                    f"反码（无点分十进制）: {complement_decimal_no_dot}\n"
                    f"反码（十六进制）: {complement_hex}"
                )

            # 判断是否为点分十六进制格式
            elif all(len(part) == 2 and all(c in '0123456789ABCDEF' for c in part) for part in ip_parts):
                ip_decimal = '.'.join(str(int(part, 16)) for part in ip_parts)
                ip_decimal_no_dot = sum(int(part, 16) << (8 * (3 - i)) for i, part in enumerate(ip_parts))
                ip_binary = '.'.join(format(int(part, 16), '08b') for part in ip_parts)
                # 计算反码
                complement_binary = '.'.join(format(255 - int(part, 16), '08b') for part in ip_parts)
                complement_decimal = '.'.join(str(255 - int(part, 16)) for part in ip_parts)
                complement_decimal_no_dot = 4294967295 - ip_decimal_no_dot
                complement_hex = ''.join(format(255 - int(part, 16), '02X') for part in ip_parts)  # 无点分十六进制
                return (
                    f"十六进制: {ip_hex}\n"
                    f"十进制: {ip_decimal}\n"
                    f"无点分十进制: {ip_decimal_no_dot}\n"
                    f"二进制: {ip_binary}\n\n"
                    f"反码（十进制）: {complement_decimal}\n"
                    f"反码（二进制）:\n{complement_binary}\n"
                    f"反码（无点分十进制）: {complement_decimal_no_dot}\n"
                    f"反码（十六进制）: {complement_hex}"
                )

        # 如果输入是没有点分隔符的十六进制字符串（例如C0A80001）
        elif len(ip_input) == 8 and all(c in '0123456789ABCDEF' for c in ip_input):
            ip_decimal_no_dot = int(ip_input, 16)
            ip_decimal = f"{(ip_decimal_no_dot >> 24) & 255}.{(ip_decimal_no_dot >> 16) & 255}.{(ip_decimal_no_dot >> 8) & 255}.{ip_decimal_no_dot & 255}"
            ip_binary = '.'.join(format(int(part), '08b') for part in ip_decimal.split('.'))
            # 计算反码
            complement_binary = '.'.join(format(255 - int(part), '08b') for part in ip_decimal.split('.'))
            complement_decimal = '.'.join(str(255 - int(part)) for part in ip_decimal.split('.'))
            complement_decimal_no_dot = 4294967295 - ip_decimal_no_dot
            complement_hex = ''.join(format(255 - int(part), '02X') for part in ip_decimal.split('.'))  # 无点分十六进制
            return (
                f"十六进制: {ip_input}\n"
                f"十进制: {ip_decimal}\n"
                f"无点分十进制: {ip_decimal_no_dot}\n"
                f"二进制: {ip_binary}\n\n"
                f"反码（二进制）:\n{complement_binary}\n"
                f"反码（十进制）: {complement_decimal}\n"
                f"反码（无点分十进制）: {complement_decimal_no_dot}\n"
                f"反码（十六进制）: {complement_hex}"
            )

        # 如果输入是无点分隔符的十进制数（例如3232235521）
        elif ip_input.isdigit():
            decimal_value = int(ip_input)
            if decimal_value < 0 or decimal_value > 4294967295:
                raise ValueError("超出有效十进制IP范围")
            # 将十进制数转换为点分格式
            ip_decimal = f"{(decimal_value >> 24) & 255}.{(decimal_value >> 16) & 255}.{(decimal_value >> 8) & 255}.{decimal_value & 255}"
            ip_binary = '.'.join(format(int(part), '08b') for part in ip_decimal.split('.'))
            ip_hex = ''.join(format(int(part), '02X') for part in ip_decimal.split('.'))  # 无点分十六进制
            # 计算反码
            complement_binary = '.'.join(format(255 - int(part), '08b') for part in ip_decimal.split('.'))
            complement_decimal = '.'.join(str(255 - int(part)) for part in ip_decimal.split('.'))
            complement_decimal_no_dot = 4294967295 - decimal_value
            complement_hex = ''.join(format(255 - int(part), '02X') for part in ip_decimal.split('.'))  # 无点分十六进制
            return (
                f"对应点分进制: {ip_decimal}\n"
                f"无点分十进制: {decimal_value}\n"
                f"二进制: {ip_binary}\n"
                f"十六进制: {ip_hex}\n\n"
                f"反码（二进制）:\n {complement_binary}\n"
                f"反码（十进制）: {complement_decimal}\n"
                f"反码（无点分十进制）: {complement_decimal_no_dot}\n"
                f"反码（十六进制）: {complement_hex}"
            )

        else:
            raise ValueError("无效的IP地址格式")

    except ValueError as e:
        return f"转换失败: {str(e)}"
