#!/bin/bash
f=$(pwd)
 

# iPhone Spotlight iOS 5-6, Settings iOS 5-8
sips --resampleWidth 29 "${f}/${1}" --out "${f}/iPhoneSpotlight-29.png"
sips --resampleWidth 58 "${f}/${1}" --out "${f}/iPhoneSpotlight-29@2x.png"
sips --resampleWidth 87 "${f}/${1}" --out "${f}/iPhoneSpotlight-29@3x.png"

# iPhone Spotlight iOS 7,8
sips --resampleWidth 80 "${f}/${1}" --out "${f}/iPhoneSpotlight-40@2x.png"
sips --resampleWidth 120 "${f}/${1}" --out "${f}/iPhoneSpotlight-40@3x.png"

# iPhone iOS 5,6
sips --resampleWidth 57 "${f}/${1}" --out "${f}/iPhone-57.png"
sips --resampleWidth 114 "${f}/${1}" --out "${f}/iPhone57@2x.png"

# iPhone iOS 7,8
sips --resampleWidth 120 "${f}/${1}" --out "${f}/iPhone-60@2x.png"
sips --resampleWidth 180 "${f}/${1}" --out "${f}/iPhone-60@3x.png"

# iPad Settings iOS 5-8
sips --resampleWidth 29 "${f}/${1}" --out "${f}/iPadSettings-29.png"
sips --resampleWidth 58 "${f}/${1}" --out "${f}/iPadSettings-29@2x.png"

# iPad Spotlight iOS 7,8
sips --resampleWidth 40 "${f}/${1}" --out "${f}/iPadSpotlight-40.png"
sips --resampleWidth 80 "${f}/${1}" --out "${f}/iPadSpotlight-40@2x.png"

# iPad App iOS 7,8
sips --resampleWidth 76 "${f}/${1}" --out "${f}/iPad-76.png"
sips --resampleWidth 152 "${f}/${1}" --out "${f}/iPad-76@2x.png"

# Apple Watch (38mm, 42mm)

# Notification Center (48, 55)
sips --resampleWidth 48 "${f}/${1}" --out "${f}/Watch-38-NotificationCenter-48.png"
sips --resampleWidth 55 "${f}/${1}" --out "${f}/Watch-42-NotificationCenter-55.png"

# Long-look (88 for 42)
# Long-look for 38 is shared with "Home"
sips --resampleWidth 88 "${f}/${1}" --out "${f}/Watch-42-LongLook-88.png"

# Home (80, 80)
sips --resampleWidth 80 "${f}/${1}" --out "${f}/Watch-38-42-Home-80.png"

# Short Look (172, 196)
sips --resampleWidth 172 "${f}/${1}" --out "${f}/Watch-38-ShortLook-172.png"
sips --resampleWidth 196 "${f}/${1}" --out "${f}/Watch-42-ShortLook-196.png"

# Companion Settings (2x, 3x)
sips --resampleWidth 58 "${f}/${1}" --out "${f}/WatchCompanionSettings-29@2x.png"
sips --resampleWidth 87 "${f}/${1}" --out "${f}/WatchCompanionSettings-29@3x.png"


