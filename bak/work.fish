#!/opt/homebrew/bin/fish
for i in *.md
        awk '{sub("{% note", "{% fold"); print}' "$i" > tmp && mv tmp "$i"
        awk '{sub("{% endnote %}", "{% endfold %}"); print}' "$i" > tmp && mv tmp "$i"
end
