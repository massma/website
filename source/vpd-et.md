---
pagetitle: "Plants and aridity research"
---

Does increasing atmospheric dryness increase or reduce evaporation?
==========================================================================

The goal of this project was to determine if there is more or less
evaporation[^1] from the land surface when dryness in the the
air[^2] increases. This is a particularly **relevant problem because
atmospheric aridity is expected in increase in the future**, and it is
an interesting problem because there are two competing factors:

1.  Plants can sense increasing dryness in the air and close up the
    pores (stomata) on their leaves to conserve water for later use.
    This closure reduces evaporation.

2.  Drier air naturally demands more water from the land surface,
    encouraging evaporation.

So the answer to whether evaporation increases or decreases in
response to drier air comes down to which effect dominates: plant
response (reduces evaporation) or atmospheric demand (increases
evaporation). To test which effect dominates we developed a very
simplified analytical model based on recent results blending
observations and plant theory. According to the model, ecosystems are
capable of a broad range of behavior in response to increased
atmospheric dryness, from strongly reducing evaporation to allowing
large increases evaporation. Ecosystem behavior depends both on
environmental conditions and plant type. For example, to access carbon
in the air plants must keep stomata open. So, plants that were bred or
evolved to prioritize carbon gain (e.g. growth) over water
conservation will tend to keep stomata open even as aridity increases.
For these plant types (e.g. many crops), evaporation will likely
increase in response to increasing aridity. However, other plant types
like many conifer trees prioritize resilience to aridity over growth,
and are more likely to close their stomata in response to aridity. For
these plant types, evaporation will likely decrease in response to
atmospheric aridity. See the
[paper](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019MS001790)
for more detail: for example the role of the environment, etc.

As an aside, the design of the project allowed us to test a range of
proposed mathematical models for plants\' stomatal behavior. While in
our analyses we used a [newer model by Medlyn and
coauthors](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1365-2486.2010.02375.x)
that blends theory and observations, we found that had we used
different models our results would have been drastically different:
the shape of the dryness-evaporation curve completely changes
depending on model choice! We would hope that different models of the
same physical processes would give qualitatively similar results (that
is, they would only differ in the details), but this is not the
case. This is all somewhat troubling, especially because different
land surface and earth system models (\"climate models\") vary in
their choice of stomatal model, and there is no consensus on which
model is most representative of plant behavior (I would guess that it
even depends on the plant type and environmental conditions). To me,
the identification of this **divergence (and contradiction) in
stomatal model behavior was our most noteworthy result**. It really
highlights the need for future research understanding plant response
at the ecosystem scale: plant response to dryness is very much an open
area of research. I would be skeptical of anyone with strongly held
convictions on the nature of the evaporation response to increased
atmospheric dryness! Hopefully in a few years we as a community can
reach consensus on how to model plant response, and we can redo our
analysis; we might even get very different results :).

Links
-----

-   [Github repository for the
    project](https://github.com/massma/climate_et)
-   Manuscript in [the Journal of Advances in Modeling Earth
    Systems](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019MS001790)
-   Same manuscript, but on [arxiv](https://arxiv.org/abs/1805.05444).

[^1]: Evaporation as used here also includes water released by plants,
    which is often called \"transpiration\" in some circles. For more
    discussion on these terms, I
    recommend Miralles and coauthor's [really nice note on the
    topic](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2020WR028055).

[^2]: \"dryness\" as defined by vapor pressure deficit (VPD). In more
    familiar terms, as relative humidity decreases, vapor pressure
    deficit increases. However, if temperature increases and relative
    humidity stays the same, vapor pressure deficit (dryness) also
    increases. More technically: $VPD = (1-RH)e_s$, where $e_s$ is the
    [saturation vapor pressure of
    water](https://en.wikipedia.org/wiki/Vapour_pressure_of_water),
    which is an exponentially increasing function of temperature.
