using Dates

portuguese_months = [
    "janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho",
    "agosto", "setembro", "outubro", "novembro", "dezembro"
]
portuguese_months_abbrev = [
    "jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out",
    "nov", "dez"
]
portuguese_days = ["domingo", "segunda", "terça", "quarta", "quinta", "sexta", "sábado"]
portuguese_days_abbrev = ["dom", "seg", "ter", "qua", "qui", "sex", "sab"]
Dates.LOCALES["portuguese"] = Dates.DateLocale(portuguese_months, portuguese_months_abbrev, portuguese_days, portuguese_days_abbrev)

"""
    {{ cpfiletosite filenamvec }}

Copy the given files to the site.

It is used in `index.md` to copy the webpage/README.md to the final website
repository, which is needed since README.md is ignored by Franklin.
"""
function hfun_cpfiletosite(filenamevec)
    cp(filenamevec[1], joinpath("__site", filenamevec[1]); force=true)
    return ""
end

"""
    {{ blogposts }}

Add the list of blog posts contained in the `/blog/` folder.
Borrowed from JuliaLang Franklin-generated website.
"""
function hfun_blogposts(lang)
    curyear = year(Dates.today())
    io = IOBuffer()
    for year in curyear:-1:2021
        ys = "$year"
        year < curyear && write(io, "\n**$year**\n")
        for month in 12:-1:1
            ms = "0"^(month < 10) * "$month"
            base = joinpath("blog", ys, ms)
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            lines = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps  = splitext(post)[1]
                url = "/blog/$ys/$ms/$ps/"
                surl = strip(url, '/')
                title = pagevar(surl, :title)
                pubdate = pagevar(surl, :published)
                if isnothing(pubdate)
                    rawdate = Date(year, month, 1)
                    days[i] = 1
                else
                    rawdate = Date(pubdate, dateformat"d U Y")
                    days[i] = day(rawdate)
                end
                if lang[1] == "portuguese"
                    date = replace(Dates.format(rawdate, "d U YYYY", locale=lang[1]), " " => " de ")
                else
                    date = Dates.format(rawdate, "U d, YYYY")
                end
                lines[i] = "\n[$title]($url)\n$date\n"
            end
            # sort by day
            foreach(line -> write(io, line), lines[sortperm(days, rev=true)])
        end
    end
    # markdown conversion adds `<p>` beginning and end but
    # we want to  avoid this to avoid an empty separator
    r = "<div class=bloglist>\n" * 
        Franklin.fd2html(String(take!(io)), internal=true) * 
        "\n</div>\n"
    return r
end

"""
    {{ blogcomments }}

Add a comment javascript section, managed by the utterances app <https://utteranc.es>.
"""
function hfun_blogcomments()
    html_str = """
    <script src="https://utteranc.es/client.js"
        repo="rmsrosa/blog_comments"
        issue-term="pathname"
        theme="github-light"
        crossorigin="anonymous"
        async>
    </script>
    """
    return html_str
end
