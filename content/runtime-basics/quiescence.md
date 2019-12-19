---
title: "Quiescence"
section: "Runtime Basics"
menu:
  toc:
    parent: "runtime-basics"
    weight: 20
toc: true
---

Quiescence is perhaps a term you are unfamiliar with unless you have worked with actor systems previously. In short, quiescence is the state of being calm or otherwise inactive. In Pony, both actors and the program can be quiescent.

Individual actors are quiescence when:

+ they have an empty message queue
+ they cannot be sent new messages (i.e., there are no aliases to them)
+ they are not registered for events from the runtime (via the ASIO system)

Quiescent actors are garbage collected. This is different from an actor being "dead" -- cycles of dead actors are garbage collected, while individually quiescent actors are garbage collected. Once no more messages are being sent and no more behaviors are executing, the *quiescent* program is terminated.
