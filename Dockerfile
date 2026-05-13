FROM sharelatex/sharelatex:latest

# В базовом образе sharelatex/sharelatex:latest установлен TeX Live по схеме
# scheme-basic. Доустанавливаем то, что нужно для типичных русскоязычных
# LaTeX-проектов.
#
# Репозиторий tlmgr: историческое зеркало TL 2025 на utah. Прибито к 2025-му
# намеренно — `mirror.ctan.org` уже переехал на TL 2026, а tlmgr из base
# image (TL 2025) с ним несовместим (cross-release updates запрещены).
# Когда выйдет новый base image на TL 2026, поменяй год в TLMGR_REPO.
#
# Неочевидные имена (имя .sty != имя tlpdb-пакета):
#   - `icomma`     -> пакет `was`       ("Werner's small TeX/LaTeX packages")
#   - `mathrsfs`   -> пакет `jknapltx`  ("J. Knappen's various LaTeX packages")
#   - `nicefrac`   -> пакет `units`
#   - `subcaption` -> ставить не нужно, файл шипается внутри пакета `caption`
#   - `longtable`, `bm`, `array`, `tabularx` -> уже идут с пакетом `tools` (тянется
#     зависимостями core-LaTeX), отдельно ставить не нужно
# Если очередной пакет «not present in repository» — ищи имя в tlpdb:
#   awk '/^name / {n=$2} /<имя>\.sty/ {print n}' /usr/local/texlive/2025/tlpkg/texlive.tlpdb
#
# Список ниже сгруппирован по смыслу:
#   - Русская локализация:           collection-langcyrillic, cmap
#   - Математика:                    mathtools, was, jknapltx
#   - Типография:                    microtype, csquotes, xcolor
#   - Списки и заголовки:            enumitem, titlesec, parskip
#   - Подписи, таблицы, рисунки:     caption, booktabs, multirow, makecell,
#                                    wrapfig, float, placeins, tabulary, pdflscape
#   - Графика:                       pgf (TikZ)
#   - Код и алгоритмы:               listings, algorithms, algorithmicx
#   - Гиперссылки и PDF:             hyperref, pdfpages
#   - Подчёркивания и единицы:       ulem, soul, units, siunitx
#   - Оформление страниц:            fancyhdr, tocloft, todonotes
#   - Библиография:                  biblatex, biber
#
# Чтобы добавить ещё пакеты, допиши их в список ниже и пересобери образ:
#   docker compose build --no-cache sharelatex
#   docker compose up -d

ARG TLMGR_REPO=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/tlnet-final

RUN tlmgr option repository "${TLMGR_REPO}" \
 && tlmgr install \
      collection-langcyrillic cmap \
      mathtools was jknapltx gensymb \
      microtype csquotes xcolor \
      enumitem titlesec parskip \
      caption booktabs multirow makecell wrapfig float placeins \
      tabulary pdflscape \
      pgf \
      listings algorithms algorithmicx \
      hyperref pdfpages \
      ulem soul units siunitx \
      fancyhdr tocloft todonotes \
      biblatex biber \
 && tlmgr path add
