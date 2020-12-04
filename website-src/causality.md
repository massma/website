---
pagetitle: "Causality as clarifier: Examples from climate science"
---

Causality as clarifier: Examples from climate science
==========================================================================

There has been a ton of recent work attempting to "discover" causal
structure from data in climate science (Jakob Runge and coauthors'
[review paper](https://www.nature.com/articles/s41467-019-10105-3)
gives a nice summary).

However this project looks at causality through a very different lens
and examines how causal graphs, a fundamental from causal theory, can
be used to clarify assumptions, identify tractable problems, and aid
interpretation of results in climate science research. The goal is to
[distill](https://distill.pub/2017/research-debt/) the basics of
causality in a way that is relatable for climate scientists.

#### A causal graph is a diagram

To build a causal graph, a researcher draws arrows from causes to
affected variables. Here is a toy (simplified) example involving
sunlight (at the earth's surface), clouds, and aerosols[^1]:

![A toy example of a causal graph](dot/cloud-aerosol.png)

From a young age we know that clouds reduce sunlight (arrow from cloud
to sunlight). Aerosols also reduce sunlight by reflecting it back to
space (arrow from aerosol to sunlight), and they also impact clouds by
providing a surface for water vapor in the air to condense/deposit
onto (arrow from cloud to sunlight). These diagrams are super intuitive
for many domain scientists to draw, but they also have a formal
mathematical meaning with rigorous underlying theory[^2].

#### Applications of causal graph theory

One of the powers of causal graphs' underlying theory is that we can
automatically analyze from the graph which variables we need to
control for in order to calculate a causal effect, and if calculating
a causal effect is possible. An example may help here as
well. Consider a situation where we have observations of cloud and
sunlight, and we want to calculate our expectation for how much
sunlight would decrease if we artificially added clouds on a sunny
day. If we naively just bin data between cloudy and clear days, and
calculate the difference in sunlight between each day:

![](fig/naiveCloudSunlight.png)

We find that the average decrease in sunlight on cloudy days is about
160 W/m^2 [^3]. However, because we drew a causal graph we can analyze
if we need to control for any other variables to calculate the true
causal effect of "playing god" and adding a cloud to our sunny
day. Details are in the paper, but if we do this we find that we need
to control for aerosol. Doing that with regression (again details are
in the paper):

![Calculating an effect by controlling for aerosol](fig/naiveCloudSunlight.png)

calculates a causal effect of cloud on sunlight of 68.5 W / m^2, much
less than our original estimate of 160 W / m^2. This toy example was
also done on generated, rather than real data, so we know the "true"
causal effect, which is 68.5 W / m^2. So if we do not adjust for
aerosol, we get a very wrong estimate of our causal effect! Also, in
the case that aerosol data are not available, we cannot calculate a
causal effect, no matter how many samples of cloud and sunlight are
available. In this way, we can analyze our causal graphs in light of
available observations to determine whether calculating a causal
effect is possible, before we have to deal with any tedious (and time
consuming) collection or downloading of data! To summarize, causal
graphs allow us to:

1. Communicate in an intuitive way our assumptions about dependencies
   between variables in a system.
2. Automatically analyze which variables we must control for to lend a
   causal (rather then correlational) interpretation to our analysis.
3. Filter out tractable vs intractable causal questions given
   available data, before we spend a lot of time analyzing data.

However, even if a causal interpretation is impossible given our
graph, we think it is still very useful to draw a causal graph and
present it with the research. It still communicates the researchers'
assumptions about how the system works, and communication is hard
enough so we should use all tools available. Also, from the graph
readers/viewers can analyze the possible sources of confounding and
co-variation that could not be accounted for in the analysis, and
reason about what their impact may have been (for example, large or
small, or positive or negative).

#### Moving beyond toys

Toy examples are useful for understanding, but are causal graphs
useful for real applications? I went back to an an old [field
campaign](http://www.atmos.albany.edu/student/massmann/ccope.html) I
was a part of at UAlbany. We were trying to estimate the effect of
rain regime[^4] on rainfall patterns in the Nahuelbuta mountains in
Chile. Here is a graph for that system:

![Graph for the
[CCOPE](http://www.atmos.albany.edu/student/massmann/ccope.html) field
campaign](dot/ccope.png)

The details of what everything means aren't that important. What is
important is that it is impossible or too expensive to observe
everything (any variable with a dashed circle is unobserved), but if
we analyze the graph in terms of what we did observe during the
campaign, we find that **we can calculate the causal effect of rain
regime on mountain rainfall**, which was the goal of the project. This
comes as no surprise to me, because the designers of the campaign
([René Garreaud](http://www.dgf.uchile.cl/rene/), [Justin
Minder](http://www.atmos.albany.edu/facstaff/jminder/), and
[Jefferson Snider](https://www.uwyo.edu/atsc/directory/faculty/snider/index.html
)) are atmospheric science wizards.

This example demonstrates how causal graphs can communicate
assumptions and lend a mathematically justified causal interpretation
to real problems in climate. The causal graphs could have been
included in the field campaign's proposal, improving communication
about the system and also rigorously justifying the campaign's
observations as necessary for calculating a causal effect. When
proposing any field campaign, we could even start with a causal graph,
and then analyze the causal graph to determine which observations we
need to meet our campaign's goals. We can even attach costs to
observing different variables, and automatically determine the set of
observations that allows us to calculate our causal effect while
minimizing cost. This type of prior analysis could be something to
consider on any future field proposals.

This is just one example to show that graphs can be useful, but there
are many more possibilities. For example in the modeling world where
writing model output can take a lot of time, one could minimize
run-time by optimizing which variables need to be saved to calculate
the effect of interest. More generally, (and I know I'm getting
repetitive but I want to hammer it home) causal graphs are useful
communicators of assumptions, and for structuring/organizing analyses.

#### Last comment

That was way longer than I expected; apologies. Despite the length I
glossed over or neglected a bunch of important details. We should have
a paper with all of these details up on arXiv soon; I am just
wrinkling out some final details in the presentation with my
collaborators. If you want a copy of the draft, just shoot me an email
(akm2203@columbia.edu).

Finally, the big takeaway is: **try drawing a causal graph as a first
step in your next project, they can help clarify a lot**.

------------
[^1]: "aerosols" are tiny particles that float in the air.

[^2]: one of my biggest regrets is that I did not learn about these
    until I was a Ph.D. student. I would have loved a math class
    growing up where we were encouraged to draw diagrams for
    complicated problems, and then view these as valid mathematical
    objects/answers themselves. I think there is a lot of opportunity
    for causal graphs in K-12 education, but I am not super up on that
    literature so maybe people are already introducing that.

[^3]: W / m^2 is a measure of the amount of sunlight. It has units of
    energy per unit time, per a square meter of the Earth's surface.

[^4]: These rain regimes were microphysical, which in this case just
    means we were interested in whether ice falling into
    rain clouds would change patterns of rainfall.
