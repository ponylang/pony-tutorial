---
title: "Lexicon"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 10
toc: true
---

Words are hard. We can all be saying the same thing but do we _mean_ the same thing? It's tough to know. Hopefully, this lexicon helps a little.

## Terminology

**Braces**: { }. Synonymous with curly brackets.

**Brackets**: This term is ambiguous. In the UK it usually means ( ) in the US is usually means [ ]. It should, therefore, be avoided for use for either of these. Can be used as a general term for any unspecified grouping punctuation, including { }.

**Compatible type**: Two types are compatible if there can be any single object which is an instance of both types. Note that a suitable type for the single object does not have to have been defined, as long as it could be. For example, any two traits are compatible because a class could be defined that provides both of them, even if such a class has not been defined. Conversely, no two classes can ever be compatible because no object can be an instance of both.

**Compound type**: A type combining multiple other types, ie union, intersection, and tuple. Opposite of a single type.

**Concrete type**: An actor, class or primitive.

**Curly brackets**: { }. Synonymous with braces.

**Declaration** and **definition**: synonyms for each other, we do not draw the C distinction between forward declarations and full definitions.

**Default method body**: Method body defined in a trait and optionally used by concrete types.

**Entity**: Top level definition within a file, ie alias, trait, actor, class, primitive.

**Explicit type**: An actor, class or primitive.

**Member**: Method or field.

**Method**: Something callable on a concrete type/object. Function, behaviour or constructor.

**Override**: When a concrete type has its own body for a method with a default body provided by a trait.

**Parentheses**: ( ). Synonymous with round brackets.

**Provide**: An entity's usage of traits and the methods they contain. Equivalent to implements or inherits from.

**Round brackets**: ( ). Synonymous with parentheses.

**Single type**: Any type which is not defined as a collection of other types. Actors, classes, primitives, traits and structural types are all single types. Opposite of a compound type.

**Square brackets**: [ ]

**Trait clash**: A trait clashes with another type if it contains a method with the same name, but incompatible signature as a method in the other type. A clashing trait is incompatible with the other type. Traits can clash with actors, classes, primitives, intersections, structural types and other traits.
