# pollutants-app
Pollutants app (starting with DDT, PFAS, microplastics) with CalCOFI regional partners

![](./figures/screen_app_dde.png)

## html

These web pages (\*.html) are typically rendered from Rmarkdown (\*.Rmd) or Quarto markdown (\*.qmd) :

<!-- Jekyll rendering: https://marineenergy.github.io/apps/ -->
{% for file in site.static_files %}
  {% if file.extname == '.html' %}
* [{{ file.basename }}]({{ site.baseurl }}{{ file.path }})
  {% endif %}
{% endfor %}

## source

See https://github.com/CalCOFI/scripts
