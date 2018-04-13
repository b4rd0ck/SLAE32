#!/bin/sh

printUsage() {
  echo "
$0 -k <key> -s <shellcode file>
"
}

KEY=''
SHELLCODE_FILE=''

while getopts :k:s: PARM; do
  case $PARM in
    k) if [ -z "$OPTARG" ]; then
         printUsage
         exit 1
       else
         KEY=$OPTARG
       fi
       ;;
    s) if [ -z "$OPTARG" ]; then
         printUsage
         exit 2
       else
         SHELLCODE_FILE=$OPTARG
       fi
       ;;
    *) printUsage
       exit 3
       ;;
  esac
done

if [ -z "$KEY" ]; then
  printUsage
  exit 4
fi

if [ -z "$SHELLCODE_FILE" ]; then
  printUsage
  exit 5
fi

if [ ! -f "$SHELLCODE_FILE" ]; then
  printUsage
  exit 6
fi

gawk -lordchr -v RS='\' -v key=$KEY ' BEGIN {
                                              MAX_KEY_LENGTH = 256;
                                              key_length = length(key);

                                              for (a = 1; a <= key_length; a++) {
                                                rc4_key[a - 1] = ord(substr(key, a, 1));
                                              }

                                              #
                                              # Key-scheduling algorithm (KSA)
                                              #
                                              for (a = 0; a < MAX_KEY_LENGTH; a++) {
                                                rc4_s[a] = a;
                                              }
                                              b = 0;
                                              for (a = 0; a < MAX_KEY_LENGTH; a++) {
                                                b = (b + rc4_s[a] + rc4_key[a % key_length]) % MAX_KEY_LENGTH;
                                                t = rc4_s[a];
                                                rc4_s[a] = rc4_s[b];
                                                rc4_s[b] = t;
                                              }

                                              rc4a = 0;
                                              rc4b = 0;
                                              printf "\n\n";
                                            }
                                            {
                                              #
                                              # Pseudo-random generation algorithm (PRGA)
                                              #
                                              hex_value = substr($0, 2);
                                              if (length(hex_value) > 0) {
                                                rc4a = (rc4a + 1) % MAX_KEY_LENGTH;
                                                rc4b = (rc4b + rc4_s[rc4a]) % MAX_KEY_LENGTH;
                                                t = rc4_s[rc4a];
                                                rc4_s[rc4a] = rc4_s[rc4b];
                                                rc4_s[rc4b] = t;
                                                k = rc4_s[(rc4_s[rc4a] + rc4_s[rc4b]) % MAX_KEY_LENGTH];
                                                dec_value = strtonum("0x" hex_value);
                                                printf "\\x%.02x", xor(k, dec_value);
                                              }
                                            }
                                      END   { printf "\n\n"; }' $SHELLCODE_FILE
exit 0
