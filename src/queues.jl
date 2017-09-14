# --------------------------------------------
# this file is part of PFlow.jl
# it implements the queuing
# --------------------------------------------
# author: Paul Bayer, Paul.Bayer@gleichsam.de
# --------------------------------------------
# license: MIT
# --------------------------------------------

function isempty(q::PFQueue)
#    @assert length(q.queue) == q.res.level "isempty: PFQueue $(q.name) not synchronized"
    DataStructures.isempty(q.queue)
end

"""
    isfull(q::PFQueue)

check, if a PFQueue is full
"""
function isfull(q::PFQueue)
#    @assert length(q.queue) == q.res.level "isfull: PFQueue $(q.name) not synchronized"
    length(q.queue) ≥ q.res.capacity
end

"""
    capacity(q::PFQueue)

return the maximum length of a PFQueue
"""
capacity(q::PFQueue) = q.res.capacity

length(q::PFQueue) = length(q.queue)

front(q::PFQueue) = DataStructures.front(q.queue)
back(q::PFQueue) = DataStructures.back(q.queue)

"""
    enqueue!(q::PFQueue, p::Product)

wait for a place, enqueue x at the end of q.queue and return q.queue
"""
function enqueue!(q::PFQueue, p::Product)
    while isfull(q)
        yield(Timeout(q.res.env, 1)) # yield(Put(...)) is not secure
    end
    Put(q.res, 1)
    DataStructures.enqueue!(q.queue, p)
end

"""
    dequeue!(q::PFQueue)

wait for something in the queue, remove it from its front and return it.
"""
function dequeue!(q::PFQueue)
    if !isempty(q)
        Get(q.res, 1)
    else
        yield(Get(q.res, 1))
        while isempty(q)
            yield(Timeout(q.res.env, 1)) # yield(Get(...)) is not secure
        end
    end
    DataStructures.dequeue!(q.queue)
end

# Iterators

start(q::PFQueue) = DataStructures.start(q.queue)
next(q::PFQueue, x) = DataStructures.next(q.queue, x)
done(q::PFQueue, x) = DataStructures.done(q.queue, x)
