#!/bin/bash

# Deploy Website:
# This creates the SiteMap and Updates the Archive. Blog, Feed and Footer must be set manually because the write Text can be different from file details.

# - Clean Output:
clear

# - Configuration: ####################################################################################################
# - - Variables:
# 1: Strings:
URL_PREFIX="https://catwithcode.moe/"
WEBSITE_NAME="CatWithCode"

# 2: Paths:
# 2.1: Files:
SITEMAP_FILE="sitemap.xml"
BLOG_FILE="blog.html"
RSS_FEED_FILE="Feed/RSS.xml"
ARCHIVE_FILE="archive.html"

# 2.2: Folders:
BLOG_DIR="Blog"

# - GENERATE ARCHIVE: ####################################################################################################

# 1: Generate the HTML-Links with indentation and sort. BR in the same line because new line befor it would glitch out find:
find . -type f ! -path '*/.*' -printf "    <a href=\"$URL_PREFIX%P\">$URL_PREFIX%P</a> <br>\n" | sort > temp_links.html

# 2: Remove Temp-Files and Script from List. Could not get it to work in one command or more cleanly:
sed -i '/DeployWebsite.sh/d' temp_links.html
sed -i '/temp_links.html/d' temp_links.html

# 3: CleanUp the old Archive:
sed -i '/<!-- ARCHIVE - START -->/,/<!-- ARCHIVE - END -->/{//!d;}' ${ARCHIVE_FILE}

# 4: Use sed to replace old Links between markers in archive.html. Is moved because read issues:
sed -e '/<!-- ARCHIVE - START -->/,/<!-- ARCHIVE - END -->/{ 
        /<!-- ARCHIVE - START -->/! { 
            /<!-- ARCHIVE - END -->/! d; 
        }
    }' \
    -e '/<!-- ARCHIVE - START -->/r temp_links.html' \
    -e 's/<!-- ARCHIVE - END -->/<!-- ARCHIVE - END -->/' \
    archive.html > temp.html

# 5: Move the temporary File back to archive.html:
mv temp.html ${ARCHIVE_FILE}

# 6: CleanUp the Temporary-Links-File:
rm temp_links.html

# 7: Update Time Step:
sed -i "s|<p>[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\} - [0-9]\{2\}:[0-9]\{2\} |<p>$(date '+%Y.%m.%d - %H:%M') |g" archive.html

# - UPDATE SITEMAP: ####################################################################################################

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

# - Update BlogPage: ####################################################################################################

# 1: Create a list of all HTML files in the Blog directory and its subfolders:
html_files=$(find "$BLOG_DIR" -type f -name "*.html" | sort)

# 2: Loop through HTML files:
while IFS= read -r html_file; do

    # 3: Get LinkDateText:
    linkDate_text=${html_file:5:10}

    # 4: Check if the Entry is already in the Blog-Entry-List:
    if ! grep -q "$html_file" "$BLOG_FILE"; then

        # 5: Getting Blog-Entry Headline:
        h1_text=$(grep -oP '(?<=<h1>).*?(?=</h1>)' "$html_file" | head -n 1)

        # 6: Add new Entry. The double Lines are for indentation and new Line:
        sed -i "/<!-- BLOG ENTRYS - START -->/a \\      <li><a href=\"$html_file\">$linkDate_text - $h1_text</a><br><br></li>\\
        " "$BLOG_FILE"

        # 7: Tell user what has been found and added:
        echo "Added $html_file to $BLOG_FILE"
    fi
done <<< "$html_files"

# - Update RSS-Feed: ####################################################################################################

# 1: Create a list of all HTML files in the Blog directory and its subfolders:
html_files_for_RSS=$(find "$BLOG_DIR" -type f -name "*.html" | sort)

# 2: Loop through HTML files:
while IFS= read -r html_file_for_RSS; do

    # 3: Check if the Entry is already in the RSS-Feed:
    if ! grep -q "$html_file_for_RSS" "$RSS_FEED_FILE"; then

        # 4: Getting Blog-Entry Headline:
        h1_text=$(grep -oP '(?<=<h1>).*?(?=</h1>)' "$html_file_for_RSS" | head -n 1)

        # 5: Getting the Blog-Entry beginning:
        # Limit seem not necessary:
        #temp_p_text=$(grep -oP '(?<=<p>).*?(?=</p>)' "$html_file_for_RSS" | head -n 1)
        #p_text=${temp_p_text:0:100}
        p_text=$(grep -oP '(?<=<p>).*?(?=</p>)' "$html_file_for_RSS" | head -n 1)

        # 6: Cleaning Discription from HTML:
        cleand_p_text=$(echo "$p_text" | sed 's/<[^>]*>//g')

        # 7: Add new RSS-Entry. The double Lines are for indentation and new Line:
        sed -i "/<!-- RSS ENTRYS - START -->/a \
        \\        <item>\n\
            <title>$WEBSITE_NAME - $h1_text</title>\n\
            <link>${URL_PREFIX}${html_file_for_RSS}</link>\n\
            <description>${cleand_p_text}\n\
            \n\
            ${URL_PREFIX}${html_file_for_RSS}\n\
            </description>\n\
        </item>" "$RSS_FEED_FILE"

        # 8: Tell user what has been found and added:
        echo "Added $html_file_for_RSS to $RSS_FEED_FILE"
    fi
done <<< "$html_files_for_RSS"

exit
