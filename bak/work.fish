#!/opt/homebrew/bin/fish
for i in *.md
    awk '{gsub("{% note", "{% fold"); print}' "$i" > tmp && mv tmp "$i"
    awk '{gsub("{% endnote %}", "{% endfold %}"); print}' "$i" > tmp && mv tmp "$i"
end
