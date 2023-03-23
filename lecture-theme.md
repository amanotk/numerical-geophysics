/* @theme lecture-theme */

@import "default";

/*
 * common
 */
.Mathjax {
  font-size: 0.8em;
}

.cjk_fallback {
  font-family: 'Noto Sans CJK JP';
  font-size: 150%;
}

header {
  top: 5px;
  color: #000;
}


footer {
  bottom: 8px;
  color: #000;
  text-align: center;
  position: fixed;
  width: 100%;
}

/*
 * title
 */
section.title h1 {
  font-family: 'Noto Sans CJK JP';
  font-style: bold;
  font-weight: 600;
  font-size: 36px;
  text-align: center;
  color: #234366;
}

section.title {
  justify-content: center;
  padding: 24px;
  font-size: 24px;
  line-height: 1;
}

/*
 * slides
 */
section h1 {
  font-family: 'Noto Sans CJK JP';
  font-style: bold;
  font-weight: 600;
  font-size: 36px;
  text-align: center;
  color: #234366;
}

section h2 {
  font-size: 32px;
  color: #234366;
}

section img {
  display: inline-block;
  margin: 0 auto;
}

section img + br + em {
    font-style: normal;
    display: inherit;
    text-align: center;
    font-size: 90%;
}

section table {
  display: table;
  width: 80%;
  border: 0 !important;
  margin: 0 auto;
}

section tr {
  background: transparent !important;
  border: 0 !important;
  display: table-row;
}

section th {
  border: 1 !important;
}

section td {
  border: 1 !important;
  display: table-cell;
  text-align: center;
  vertical-align: middle
}

section {
  justify-content: start;
  padding: 24px;
  font-family: 'Noto Sans CJK JP';
  font-style: normal;
  font-weight: 400;
  font-size: 24px;
  line-height: 1;
  color: #000;
}
