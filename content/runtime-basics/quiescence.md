---
title: "Quiescence"
section: "Runtime Basics"
menu:
  toc:
    parent: "runtime-basics"
    weight: 25
toc: true
---

Quiescence is perhaps a term you are unfamiliar with unless you have worked with actor systems previously. In short, quiescence is the state of being calm or otherwise inactive. In Pony, individual actors as well as the program can be quiescent.

Actors are quiescent when:

+ they have an empty message queue
+ they cannot be sent new messages (i.e., there are no aliases to them)
+ they are not registered for events from the runtime (via the ASIO subsystem)

Once no more messages are being sent and no more behaviors are executing, the *quiescent* program is terminated.

## Actor States

Actors can be in a variety of states stemming from being either **alive** or **dead**. Actors are alive if they have messages in their queue or can receive messages (including ASIO events), meanwhile actors are dead if they have no messages in their queue nor can receive messages (including ASIO events).

### Alive States

Alive actors have four states centered around how the scheduler is interacting with them.

+ **Waiting**: messages in its queue and waiting in the scheduler's run queue for control of a scheduler thread
+ **Running**: executing a behavior or processing a message from its queue via control of a scheduler thread
+ **Blocked**: completed execution and no messages waiting in its queue so not in scheduler's run queue
+ **Muted**: has experienced some form of backpressure and has been removed from the scheduler's run queue

### Dead States

+ **Blocked**: completed execution and no messages waiting in its queue so not in scheduler's run queue
+ **Muted**: has experienced some form of backpressure and has been removed from the run queue

---

Notice that both **Dead** states are also possible **Alive** states. An actor may transition from **Alive** to **Dead** while in one of these states -- meanwhile no transition from **Alive** to **Dead** can occur while **Waiting** or **Running**.

**Dead** actors are *quiescent* and therefore are grounds for garbage collection. Once all actors are **Dead**, the program terminates.
