#!/usr/bin/env bash
DIFF=486604799
TEXT="The Times 03/Jan/2009 Chancellor on brink of second bailout for banks";
KEY="04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f"

echo "Public Key          :" $KEY
echo "Text                :" $TEXT
echo "Difficulty          :" $DIFF
echo "Expected Block      : 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"

./blockgenSatoshi.bin $KEY "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks";
