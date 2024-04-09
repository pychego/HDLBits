import re
# ********绝密********
# 终于实现了将^2换成pow( ,2) 并且将abs换成fabs了
def replace_expression(expression):
    # 使用正则表达式找到所有(expression)^2的匹配项
    pattern = re.compile(r'\)\^2')

    while re.search(pattern, expression):
        match = re.search(pattern, expression)
        end_index = match.start()
        
        # 从end_index往前找到最后一个匹配的'('
        start_index = None
        count = 0
        for i in range(end_index, -1, -1):
            if expression[i] == ')':
                count += 1
            elif expression[i] == '(':
                count -= 1
                if count == 0:
                    start_index = i
                    break
        
        if start_index is not None:
            subexpression = expression[start_index+1:end_index]
            replacement = f'(pow({subexpression}, 2))'
            expression = expression[:start_index] + replacement + expression[end_index+3:]
        else:
            # 如果找不到匹配的'('，则跳过这个匹配项
            expression = expression[:end_index] + expression[end_index+3:]

    return expression

def replace_abs(expression):
    # 使用正则表达式找到所有abs()的匹配项
    pattern = re.compile(r'abs\((.*?)\)')

    def replace_helper(match):
        subexpression = match.group(1)
        return f'fabs({subexpression})'

    # 替换匹配项
    expression = re.sub(pattern, replace_helper, expression)
    
    return expression


# 测试
text = """
(0.5*abs((y + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 10.028))*(y + y + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 20.056))/(sqrt((y + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 10.028)*(y + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 10.028))*sqrt(abs((4.0*sin(0.017453*b) - 1.0*x - 24.233*cos(0.017453*b)*cos(0.017453*c) + 6.9222*cos(0.017453*b)*sin(0.017453*c) + 35.825))^2 + abs((z - 4.0*cos(0.017453*a)*cos(0.017453*b) + 6.9222*cos(0.017453*c)*sin(0.017453*a) + 24.233*sin(0.017453*a)*sin(0.017453*c) - 24.233*cos(0.017453*a)*cos(0.017453*c)*sin(0.017453*b) + 6.9222*cos(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) - 4.0))^2 + abs((y + 6.9222*cos(0.017453*a)*cos(0.017453*c) + 4.0*cos(0.017453*b)*sin(0.017453*a) + 24.233*cos(0.017453*a)*sin(0.017453*c) + 24.233*cos(0.017453*c)*sin(0.017453*a)*sin(0.017453*b) - 6.9222*sin(0.017453*a)*sin(0.017453*b)*sin(0.017453*c) + 10.028))^2));
"""
text = replace_expression(text)
text = replace_abs(text)
print(text)
