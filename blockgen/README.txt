You need to preset the UNIX time variable and nonce to match the ones there, otherwise it will find a different one.

Genesis Block Generator
-----------------------------
April 21, 2013, 03:50:39 AM
 #1
Ok, thread title is a bit misleading, I haven't actually done the genesis block calculation part done. 
I'd like to also take a minute or two and explain to you that I aren't exactly a good coder, 
I started doing C in my early days of mining in 2011 and playing with cgminer and nonces and stuff. 
I refused to read a book on C, so everything I've learned about C is through trial&error, 
well OK I have not learned much so trial&error is how I get my results. The equivalent of this would 
be trying to drive a car as if you have 10 years behind the wheel without actually knowing how to.

So basically do not expect the best code, I could have done things in there that aren't efficient, or 
just plain simply wrong and that would be because I don't know how to do them in a different way.

The code is here http://pastebin.com/nhuuV7y9, pure C. No binaries for obvious reasons. The code relies 
on OpenSSL. Since you will need OpenSSL either way, as it is a Bitcoin dependency, I believe it won't be an issue. 
*Implemented Genesis Block finder

Cons
> Program assumes one input and one output. So trying to create a merkle hash like the one in Freicoin 
with multiple inputs and outputs is not possible with this program.
> Program at the moment assumes 50 coins, but this can be changed in the code very easily.
> This is probably the most important one. I can re-create the Bitcoin merkle hash with ease, but when I tried 
to test it with Litecoin's timestamp message, it failed. Something to do with Unicode. I will not lie, my understanding 
of Unicode and ASCII is even less than my understanding of C. Basically, try to avoid apostrophes,commas and other 
special characters. Someone more knowledgeable can patch this

Usage
program <pubkey> <timestamp> <nBits>

Example 
programname 
04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f 
"The Times 03/Jan/2009 Chancellor on brink of second bailout for banks" 
486604799

Which will output
Coinbase: 04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e6420
6261696c6f757420666f722062616e6b73

PubkeyScript: 4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d57
8a4c702b6bf11d5fac

Merkle Hash: 3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a
Byteswapped: 4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b

The timestamp needs to be in quotes if it's longer than a word, because it will get treated as separate arguments than a whole string.

So yeah, more cons than pros, but if you like what I've done, please drop some reward to the address on my signature



===============================


I tried your program with bitcoin's parameters:

Quote
$ gg 
04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f 
"The Times 03/Jan/2009 Chancellor on brink of second bailout for banks" 
486604799

Coinbase: 04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e6420
6261696c6f757420666f722062616e6b73

PubkeyScript: 4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d57
8a4c702b6bf11d5fac

Merkle Hash: 3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a
Byteswapped: 4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b
Generating block...
1054499 Hashes/s, Nonce 1279737097
Block found!
Hash: 000000000be5c9479ccf0a6a74134940650ca3690488d6a3604ea029b429f778
Nonce: 1279991239
Unix time: 1367026916

Why I don't get the same genesis hash as in the bitcoin program?
uint256 hashGenesisBlock("0x000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f");

>> It looks like you've got a linebreak/space in the first argument.  
I noticed this in OP's post too, if I double click the first argument it stops highlighting halfway through.  
If I drag-select the whole thing and paste it somewhere, there's a space.  
So, make sure you don't have any space between "bc3f" and "4cef".

>> It's because the nonce and unixtime are different.
For bitcoin, it's unixtime = 1231006505 and nonce = 2083236893
I will have to rework the program a bit and start working with switches for better control and/or parsing the data from a file.

=========================================================

OK got it. Nice, with these as initial value the genesis block come out immediately:

Quote
$ gg1 
04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f 
"The Times 03/Jan/2009 Chancellor on brink of second bailout for banks" 
486604799

Coinbase: 04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63
656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73

PubkeyScript: 4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61de
b649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac

Merkle Hash: 3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a
Byteswapped: 4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b
Generating block...

Block found!
Hash: 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
Nonce: 2083236893
Unix time: 1231006505