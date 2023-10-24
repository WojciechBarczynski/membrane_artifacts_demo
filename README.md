# How to reproduce artifact

1. `mix deps.get`
2. `mix run lib/example.exs`

# Solution / Fix

Increase UDP buffer size in `Membrane.UDP.Source` element
