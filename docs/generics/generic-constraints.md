# Constraints

## Capability Constraints

The type parameter constraint for a generic class or method can constrain to a particular capability as seen previously:

```pony
--8<-- "generics-foo-with-any-val.pony::1"
```

Without the constraint, the generic must work for all possible capabilities. Sometimes you don't want to be limited to a specific capability and you can't support all capabilities. The solution for this is generic constraint qualifiers. These represent classes of capabilities that are accepted in the generic. The valid qualifiers are:

| &#x25B7; | Capabilities allowed         | Description                                                     |
| -------- | ---------------------------- | --------------------------------------------------------------- |
| `#read`    | `ref`, `val`, `box`                | Anything you can read from                                      |
| `#send`    | `iso`, `val`, `tag`                | Anything you can send to an actor                               |
| `#share`   | `val`, `tag`                     | Anything you can send to more than one actor                    |
| `#any`     | `iso`, `trn`, `ref`, `val`, `box`, `tag` | Default of a constraint                                         |
| `#alias`   | `ref`, `val`, `box`, `tag`           | Set of capabilities that alias as themselves (used by compiler) |

In the previous section, we went through extra work to support `iso`. If there's no requirement for `iso` support we can use `#read` and support `ref`, `val`, and `box`:

```pony
--8<-- "generic-constraints-foo-any-read.pony"
```
