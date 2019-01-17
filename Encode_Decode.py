#import binascii

##def text_to_bits(text, encoding='utf-8', errors='surrogatepass'):
##    bits = bin(int.from_bytes(text.encode(encoding, errors), 'big'))[2:]
##    return bits.zfill(8 * ((len(bits) + 7) // 8))
##
##def text_from_bits(bits, encoding='utf-8', errors='surrogatepass'):
##    n = int(bits, 2)
##    return n.to_bytes((n.bit_length() + 7) // 8, 'big').decode(encoding, errors) or '\0'


##Trying with 7 length binary:
def text_to_bits(text, encoding='utf-8', errors='surrogatepass'):
    bits = bin(int.from_bytes(text.encode(encoding, errors), 'big'))[2:]
    return bits.zfill(7 * ((len(bits) + 6) // 7))

def text_from_bits(bits, encoding='utf-8', errors='surrogatepass'):
    n = int(bits, 2)
    return n.to_bytes((n.bit_length() + 6) // 7, 'big').decode(encoding, errors) or '\0'


hasher = 'abcdefghijklmnopqrstuvwxyz012345'
password = input('Enter your password:')
password = password + hasher[len(password):]
print(password)
print(text_to_bits(password))

r = input('Stop')

with open("C:/Users/Colin/Desktop/Total_Temp_File.txt") as fileobj:
    for line in fileobj:
        print(line, str(len(line)).zfill(7))
        line_in_bits = str(len(line)).zfill(7)
        line = line_in_bits + line
        print(line, len(text_to_bits(line)), text_to_bits(line))
        print(text_from_bits(text_to_bits(line)))

##            if (len(line_length) > 0) and (len(line_length) < 32):
##                line_in_bits += ch
##                print(ch, line_length)
                

#try using the *.zfill() option to populate some items to the necessary length.
#The item must be a string first.
#i.e. '14.72'.zfill(8) = '00014.72'
           
print(text_to_bits('h'))
print(text_to_bits("'\'"))

r = text_to_bits('hi')

print(text_from_bits('01000011'))

for n in range(0, 128):
    binary = str(format(n,  "b"))
    binary = binary.zfill(7 * ((len(binary) + 6) // 7))
    try:
        print(binary, int(n), text_from_bits(binary))
    except ValueError:
        print("Binary value of", binary, "does not have a character.")
    
    
