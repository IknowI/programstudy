# tuple Ԫ�� һ������ʼ�����ܱ��޸�
classmates = ('Michael','Bob','Tracy')
print(classmates )
t = (1,2)
print(t)

t1 = (1,) # ��ʾֻ��һ��Ԫ��
print(t1)

t2 = (1)
print(t2)

# ע��T2��T1������

t3 = ('a','b',['A','B'])
print(t3[2][1])

# list �б� append & pop
classmates = ['1','2','22','34']
print('classmates: ' ,classmates )

# ���һ��Ԫ��
classmates.append('342')

print('after add one element: ' , classmates )

#ɾ��һ��Ԫ��
classmates.pop(1)
print('after delete one elements: ',classmates)

# �Ӻ���ǰȡԪ��
print(classmates[-2])


'''
list��tuple��Python���õ����򼯺ϣ�һ���ɱ䣬һ�����ɱ䡣������Ҫ��ѡ��ʹ������
'''

