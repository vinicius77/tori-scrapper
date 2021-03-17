## Tori's Website Scrapper

A simple web scrapper built using Ruby that has its target the [Tori's website](https://www.tori.fi)

### Usage

Inside of the `scrapper_tori.rb` file:

```ruby
# creates a new instance of the ToriScrapper class passing as its params the term to be
# searched on the Tori's website
tori_scrapper = ToriScrapper.new("lumilauta")

# calls the class method that brings the results
tori_scrapper.get_results

# In order to simplify, it is returning only the very first and the very last products
# You can change the lines below as you wish
puts productsArr.first
puts productsArr.last

```

After calling the `get_results` it should return an object similar to:

```
{
    :title=> "Korvalämpömittari",
    :published_at=> "tänään13:26",
    :link=> "https://www.tori.fi/uusimaa/Korvalampomittari_81611260.htm?ca=18&w=1"
}
```

On the console run the command

```
ruby scrapper_tori.rb
```

Built only for learning purposes.
