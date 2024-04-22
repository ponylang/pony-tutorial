# Serialisation

Pony provides a built-in mechanism for serialising and deserialising objects so that they can be passed between Pony processes. Serialisation takes an object and turns it into an array of bytes that can be used to send the object to another process by, for example, writing it to a TCP stream. Deserialisation takes an array of bytes and turns them into a Pony object.

Pony uses an intermediate object type called `Serialised` to represent a serialised object. A `Serialised` object can be created in one of two ways:

* calling the `create(...)` constructor with the `SerialiseAuth` authority and the object to serialize
* calling the `input(...)` constructor with the `DeserialiseAuth` authority and an `Array[U8]` that represents the object to deserialise. This intermediate object can then be used to either:

    * generate an `Array[U8]` that represents the object by calling the `output(...)` method with the `OutputSerialisedAuth` authority, or
    * generate a deserialised object by calling the `apply(...)` method with the `InputSerialisedAuth` authority

This program serialises and deserialise an object, and checks that the fields of the original object are the same as the fields of the deserialised object.

```pony
--8<-- "appendices-serialization-compare-original-object-with-deserialized-object.pony"
```

## Caveats

There are several things to keep in mind when using Pony's serialisation system:

* Serialised objects will currently only work when passed between two running instances of the same Pony executable. You cannot pass objects between different Pony programs, nor can you pass them between different versions of the same program. Using the `Serialise.signature` function can help you determine if your two Pony programs are the same.
* Objects with `embed` fields will not be properly serialised.
* Objects with `Pointer` fields must use the custom serialisation mechanism or else the `Pointer` fields will be null when the object is deserialised. For information on how to handle these kinds of fields, please see the discussion of custom serialisation and deserialisation below.

## Custom Serialisation and Deserialisation

Pony objects can have `Pointer` fields that store pointers to memory that contains things that are opaque to Pony but that may be useful to code that is called via FFI. Because the objects that `Pointer` fields point to are opaque, Pony cannot serialise and deserialise them by itself. However, Pony's serialisation system provides a way for the programmer to specify how the objects pointed to by these fields should be serialised and deserialised. This system is called custom serialisation.

Since `Pointer` fields are opaque to Pony, it is assumed that the serialisation and deserialisation code will be written in another language that knows how to read the object referenced by the pointers.

### Custom Serialisation

In order to serialise an object from a pointer field, Pony needs to know how much space to set aside for that object and how to write a representation of that object into the reserved space. The programmer must provide two methods on the object:

* `fun _serialise_space(): USize` -- This method returns the number of bytes that must be reserved for the object.
* `fun _serialise(bytes: Pointer[U8] tag)` -- This method receives a pointer to the memory that has been set aside for serialising the object. The programmer must not write more bytes than were returned by the `_serialise_space` method.

### Custom Deserialisation

Custom deserialisation is handled by a `fun ref _deserialise(bytes: Pointer[U8] tag)` method. This method receives a pointer to the character array that stores the serialised representation of the object (or objects) that the `Pointer` fields should point to. The programmer must copy out any bytes that will be used by the deserialised object.

The custom deserialisation method is expected to modify the values of the objects `Pointer` fields, so the fields must be declared `var` so that they can be modified.

### Considerations

#### Fixed Versus Variable Object Sizes

The programmer must write their custom serialisation and deserialisation code in such a way that it is aware of how many bytes are available in the byte arrays that are passed to the methods. If the objects are always of a fixed size then the functions can read and write that many bytes to the buffer. However, if the objects are of varying sizes (for example, if the object was a string), then the serialized representation must include information that the deserialisation code can use to ensure that it does not read beyond the end of the memory occupied by the object. The custom serialisation system does not provide a mechanism for doing this, so it is up to the program to choose a mechanism and implement it. In the case of a string, the serialisation format could consist of a 4-byte header that encodes the length of the string, followed by a string of the specified length. These additional four bytes must be included in the value returned by `_serialise_space()`. The deserialisation function would then start by reading the first four bytes of the array to obtain the size of the string and then read only that many bytes from the array.

#### Classes With Multiple `Pointer` Fields

If a class has more than one `Pointer` field then all of those fields must be handled by the custom serialisation and deserialisation methods for that class; there are not methods for each field. For example, if a class has three `Pointer` fields then the `_serialise_space()` method must return the total number of bytes required to serialise the objects from all three fields.

### Example

Assume we have a Pony class with a field that is a pointer to a C string. We would like to be able to serialise and deserialise this object. In order to do that, the Pony class implements the methods `_serialise_space(...)`, `_serialise(...)`, and `_deserialise(...)`. These methods, in turn, call C functions that calculate the number of bytes needed to serialise the string and serialise and deserialise it. In this example the serialised string is represented by a four-byte big-endian number that represents the length of the string, followed by the string itself without the terminating null. So if the C string is `hello world\0` then the serialised string is `\0x00\0x00\0x00\0x0Bhello world` (where the first four bytes of the serialised string are a big-endian representation of the number `0x0000000B`, which is `11`).

```pony
--8<-- "appendices-serialization-custom-serialization.pony"
```

```c
--8<-- "appendices-serialization-custom-serialization.c"
```
