#!/bin/bash

if [[ -z $1 ]]; then
  group="21is19"
else
  group=$1
fi

cat ./log/$group | awk '!($0 in a) {a[$0];print}' >> ./data/$group

echo "<table>" > form_table.html
echo "<caption>  Result of $group </caption>" >> form_table.html
echo "<tr>" >> form_table.html
echo "<th> DATE </th>" >> form_table.html
echo "<th> LAB </th>" >> form_table.html
echo "<th> GROUP </th>" >> form_table.html
echo "<th> USER 1 </th>" >> form_table.html
echo "<th> USER 2 </th>" >> form_table.html
echo "<th> IP addr </th>" >> form_table.html
echo "<th> RESULT </th>" >> form_table.html
echo "</tr>" >> form_table.html

cat ./data/$group | awk -F',' '{print "<tr><td>"$1"</td><td>" $2"</td><td>" $3"</td><td>" $4"</td><td>" $5"</td><td>" $6"</td><td>" $7"</td></tr>"}' >> form_table.html
echo "</table>" >> form_table.html

rm /var/www/html/$group.html
cat form_top.html >> /var/www/html/$group.html
cat form_table.html >> /var/www/html/$group.html
cat form_bottom.html >> /var/www/html/$group.html

echo ""
echo "Press any key ..."
read
