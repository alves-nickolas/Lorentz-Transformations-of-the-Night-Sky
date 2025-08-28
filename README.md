[![Author: Níckolas de Aguiar Alves](https://img.shields.io/badge/author-Níckolas_de_Aguiar_Alves-e20134)](https://alves-nickolas.github.io/)
![Language: Asymptote](https://img.shields.io/badge/language-Asymptote-f1611a)
[![License: CC-BY 4.0](https://img.shields.io/badge/license-CC--BY_4.0-ffc100)]([https://test.latex-project.org//lppl/](https://creativecommons.org/licenses/by/4.0/))

# Lorentz Transformations of the Night Sky
By **Níckolas de Aguiar Alves**

One of my favorite facts about physics is that the Lorentz group in $d=3+1$ dimensions is the conformal group in $d=2$ dimensions. This means, among other things, that the effect of Lorentz transformations on the night sky seen by inertial observers is described by conformal transformations on the celestial sphere. This code snippet makes this visual by using astrometric data from the Yale Bright Star Catalogue to pinpoint stars in the sky, and Möbius transformations to implement the Lorentz transformations. 

## The Code

To get the positions and magnitudes of the stars, we use the Yale Bright Star Catalogue[^1]. This is accessed using Vizier[^2][^3], which in turn is queried with `astroquery`[^4]. Once the data is available, a few manipulations are done with AstroPy[^5][^6][^7] to get the coordinates in radians. Once the data is available in a `.csv` file, `Asymptote` [^8][^9] handles the plotting.

## The Physics

Maybe I'll write more about the physics involved in here at some point. For now, there is a sketch of the main ideas in Sec. 4.5 of my notes on the Bondi–Metzner–Sachs group[^10]. There you can also find some more references on the topic. A very nice discussion is given in a paper by Komar[^11] too.

## Examples

Let us get to some examples. I wrote the code so that you can change most of the parameters from the command line by adding strings of text. I won't pretend this is a detailed documentation, but maybe it helps you get started.

First, let us get a very detailed picture of the night sky. No boosts, no rotations. Just a `.png` output, high resolution, about 10 cm in size. To get all stars, we set `m_cutoff=15`. Be sure to make the sky dark. Saving it as `example-1.png`, we use the following code. 

```
asy -u "size(10cm); m_cutoff=15; dark_background=true" -render 16 -f png -o example-1 CKV.asy
```

Next we try something different. Let us allow a smaller resolution (`-render 4`), less stars (so no improving the magnitude cutoff), not changing the output size (the default is 6 cm). However, put a 90° rotation about the vertical axis to change things a bit.

```
asy -u "ang=pi/2; dark_background=true" -render 4 -f png -o example-2 CKV.asy
```

Finally, let us try a boost. To make things crystal clear, we pick something at 75% of the speed of light. 

```
asy -u "vel=0.75; dark_background=true" -render 4 -f png -o example-3 CKV.asy
```

If you want a simple visualization with a four-screw (a boost and a rotation about the same direction), which is the transformations I use in talks, try this code. Ajust the parameters of `vel` (boost velocity as a fraction of the speed of light) and `and` (rotation angle in radians) as you prefer. The `-V` setup will make the `Asymptote` visualization window popup, and show the full 3D image (you can rotate the sky around manually, for example).

```
asy -u "vel=0; ang=0; dark_background=true" -V CKV.asy
```

[^1]: D. Hoffleit and C. Jaschek. [*The Bright Star Catalogue*](https://cdsarc.cds.unistra.fr/viz-bin/cat/V/50). 5th Revised Edition. New Haven, CT: Yale University Observatory, 1999.
[^2]: F. Ochsenbein, P. Bauer, and J. Marcout. “The VizieR Database of Astronomical Catalogues”. [*Astronomy and Astrophysics Supplement Series* **143**, pp. 23–32 (2000)](https://doi.org/10.1051/aas:2000169).
[^3]: F. Ochsenbein et al. [*The VizieR Database of Astronomical Catalogues*](https://doi.org/10.26093/cds/vizier). CDS, Centre de Données astronomiques de Strasbourg, 1996.
[^4]: A. Ginsburg et al. “Astroquery: An Astronomical Web-Querying Package in Python”. [*The Astronomical Journal* **157**, 98 (2019)](https://doi.org/10.3847/1538-3881/aafc33). arXiv: [1901.04520 [astro-ph.IM]](https://arxiv.org/abs/1901.04520).
[^5]: A. M. Price-Whelan et al., The Astropy Collaboration. “The Astropy Project: Building an Inclusive, Open-Science Project and Status of the v2.0 Core Package”. [*The Astronomical Journal* **156**, 123 (2018)](https://doi.org/10.3847/1538-3881/aabc4f). arXiv: [1801.02634 [astro-ph.IM]](https://arxiv.org/abs/1801.02634).
[^6]: A. M. Price-Whelan et al., The Astropy Collaboration. “The Astropy Project: Sustaining and Growing a Community-oriented Open-source Project and the Latest Major Release (v5.0) of the Core Package”. [*The Astrophysical Journal* **935**, 167 (2022)](https://doi.org/10.3847/1538-4357/ac7c74). arXiv: [2206.14220 [astro-ph.IM]](https://arxiv.org/abs/2206.14220).
[^7]: T. P. Robitaille et al., The Astropy Collaboration. “Astropy: A Community Python Package for Astronomy”. [*Astronomy & Astrophysics* **558**, A33 (2013)](https://doi.org/10.1051/0004-6361/201322068). arXiv: [1307.6212 [astro-ph.IM]](https://arxiv.org/abs/1307.6212).
[^8]: J. Bowman and A. Hammerlindl. “Asymptote: A Vector Graphics Language”. [*TUGboat: The Communications of the TeX Users Group* **29**, pp. 288–294 (2008)](https://tug.org/TUGboat/Contents/contents29-2.html).
[^9]: A. Hammerlindl, J. C. Bowman, and R. T. Prince. [*Asymptote: A Descriptive Vector Graphics Language*](http://asymptote.sourceforge.net/). 2004.
[^10]: N. de Aguiar Alves. “*Lectures on the Bondi–Metzner–Sachs Group and Related Topics in Infrared Physics*”. 2025. arXiv: [2504.12521 [gr-qc]](https://arxiv.org/abs/2504.12521).
[^11]: A. Komar. “Foundations of Special Relativity and the Shape of the Big Dipper”. [*American Journal of Physics* **33**, pp. 1024–1027 (1965)](https://doi.org/10.1119/1.1971138).
