#python3
# generates 3 chars parts of uuid for the level external id
import shortuuid as sid
abc = "23456789abcdefghijkmnopqrstuvwxyz"
sid.set_alphabet(abc)
for i in range(10):
    print (sid.uuid()[:3])
    
