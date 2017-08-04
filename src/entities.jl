# --------------------------------------------
# this file is part of PFlow.jl
# it implements the data structures
# --------------------------------------------
# author: Paul Bayer, Paul.Bayer@gleichsam.de
# --------------------------------------------
# license: MIT
# --------------------------------------------

const IDLE = 0
const WORKING = 1
const FAILURE = 2
const BLOCKED = 3

const OPEN = 0
const PROGRESS = 1
const DONE = 2

const MACHINE = 0
const WORKER = 1
const TRANSPORT = 2
const INSPECTOR = 3
const STORE = 4

mutable struct PFQueue
  name::AbstractString
  res::Resource
  queue::Queue
end

mutable struct Workunit
  name::AbstractString
  kind::Int64
  input::PFQueue
  jobs::PFQueue
  output::PFQueue
  alpha::Int64               # Erlang scale parameter
  mtbf::Number
  mttr::Number
end

mutable struct Job
  name::AbstractString
  wu::AbstractString
  op_time::Real
  status::Int64
  batch_size::Int64
  target::AbstractString     # name of target for transport jobs
end

mutable struct Order
  name::AbstractString
  seq::OrderedDict{AbstractString, Job}
end
