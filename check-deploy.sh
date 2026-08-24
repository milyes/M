#!/bin/bash
echo "🔍 Z-CORE HEALTH CHECK..."
echo ""

# 1. Check Firebase
echo "1. FIREBASE:"
curl -s -o /dev/null -w "%{http_code}" https://iron-byte-378404.web.app
if [ $? -eq 0 ]; then echo " ✅ ONLINE"; else echo " ❌ OFFLINE"; fi

# 2. Check GitHub Root
echo "2. GITHUB ROOT:"
curl -s -o /dev/null -w "%{http_code}" https://milyes.github.io
if [ $? -eq 0 ]; then echo " ✅ ONLINE"; else echo " ❌ 404"; fi

# 3. Check GitHub /M/
echo "3. GITHUB /M/:"
curl -s -o /dev/null -w "%{http_code}" https://milyes.github.io/M/prompts_netsecurepro_ia22.html
if [ $? -eq 0 ]; then echo " ✅ ONLINE"; else echo " ❌ OFFLINE"; fi

echo ""
echo "SIGN_LOGIC: Z-CORE STATUS COMPLET"
