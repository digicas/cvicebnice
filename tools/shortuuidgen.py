#python3
# generates 3 chars parts of uuid for the level external id
import shortuuid as sid
# abc = "23456789abcdefghijkmnopqrstuvwxyz"
# it is more convenient to avoid numbers on mobile devices
abc = "abcdefghijkmnopqrstuvwxyz"
sid.set_alphabet(abc)
for i in range(2000):
    print (sid.uuid()[:3])
    
