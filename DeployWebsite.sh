#!/bin/bash

# Deploy Website:
# This creates the SiteMap and Updates the Archive. Blog, Feed and Footer must be set manually because the write Text can be different from file details.

# - Configuration:
# Variables:
# URL:
URL_PREFIX="https://catwithcode.moe/"

# Sitemap:
# File:
SITEMAP_FILE="sitemap.xml"

# - GENERATE ARCHIVE:

# 1: Generate the HTML-Links with indentation and sort. BR in the same line because new line befor it would glitch out find:
find . -type f ! -path '*/.*' -printf "    <a href=\"$URL_PREFIX%P\">$URL_PREFIX%P</a> <br>\n" | sort > temp_links.html

# 2: Remove Temp-Files and Script from List. Could not get it to work in one command or more cleanly:
sed -i '/DeployWebsite.sh/d' temp_links.html
sed -i '/temp_links.html/d' temp_links.html

# 3: Use sed to replace old Links between markers in archive.html. Is moved because read issues:
sed -e '/<!-- ARCHIVE - START -->/,/<!-- ARCHIVE - END -->/{ 
        /<!-- ARCHIVE - START -->/! { 
            /<!-- ARCHIVE - END -->/! d; 
        }
    }' \
    -e '/<!-- ARCHIVE - START -->/r temp_links.html' \
    -e 's/<!-- ARCHIVE - END -->/<!-- ARCHIVE - END -->/' \
    archive.html > temp.html

# 4: Move the temporary File back to archive.html:
mv temp.html archive.html

# 5: CleanUp the Temporary-Links-File:
rm temp_links.html

# 6: Update Time Step:
sed -i "s|<p>[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\} - [0-9]\{2\}:[0-9]\{2\} |<p>$(date '+%Y.%m.%d - %H:%M') |g" archive.html

# - UPDATE SITEMAP:

# 1: CleanUp old SideMap:
> "$SITEMAP_FILE"

# 2: Formating:
# Beinning, moved here because of text inside other Files or of File creation itself:
echo '<?xml version="1.0" encoding="UTF-8"?>' >> "$SITEMAP_FILE"
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> "$SITEMAP_FILE"

# 3: Find all HTML files:
find . -type f -name "*.html" | sort | while read -r file; do
     # 5: Get the last modified date in YYYY-MM-DD format because best example:
     last_modified=$(date -u -d "$(stat -c %y "$file")" +"%Y-%m-%d")
    
     # 6: Create the URL and removing the leading './' from the file path
     relative_path="${file#./}"
     url="${URL_PREFIX}${relative_path//\//\/}"

     # 7: Add URL and last modified date to sitemap:
     echo "  <url>" >> "$SITEMAP_FILE"
     echo "    <loc>$url</loc>" >> "$SITEMAP_FILE"
     echo "    <lastmod>$last_modified</lastmod>" >> "$SITEMAP_FILE"
     echo "  </url>" >> "$SITEMAP_FILE"
done

# 8: End Sitemap XML:
echo '</urlset>' >> "$SITEMAP_FILE"

exit
