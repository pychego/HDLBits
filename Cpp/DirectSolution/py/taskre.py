import re

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
            replacement = f'pow({subexpression}, 2)'
            expression = expression[:start_index] + replacement + expression[end_index+3:]
        else:
            # 如果找不到匹配的'('，则跳过这个匹配项
            expression = expression[:end_index] + expression[end_index+3:]

    return expression

# 测试代码
input_expression = "((9())^2"
output_expression = replace_expression(input_expression)
print(output_expression)