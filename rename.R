pacman::p_load(
    Ipaper,
    data.table,
    dplyr,
    jsonlite
)

fs = dir2("./MinerU/", "*.md", recursive = TRUE)

tmp = foreach(f = fs, i = icount()) %do%
    {
        # f = fs[1]
        f_meta = gsub("full.md", "manifest.json", f)
        l = read_json(f_meta, simplifyVector = TRUE)
        title = l$sections$heading[1]
        fout = glue("{title}.md")
        fout = sprintf("%s/%s", dirname(f), fout)
        file.rename(f, fout)
    }

fs = dir2("./MinerU/", "*.pdf", recursive = TRUE)
fs_new = gsub(".pdf", ".md", fs)
file.rename(fs, fs_new)
