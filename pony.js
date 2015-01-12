/*
  Language: Pony
  Author: Causality Ltd (developers@causality.io)
  Category: common, system, high performance
 */

  function(hljs) {
  	var PONY_KEYWORDS = {
  		keyword: 'type interface trait primitive class actor new be fun iso ' +
  		'trn ref val box tag if then elseif else end match where try with ' +
  		'recover consume object while do repeat until for in is isnt not ' +
  		'and or xor compiler_intrinsic use var let break continue ? => ' +
  		'return error',
  		built_in: 'Arithmetic Logical Bits ArithmeticConvertible Real ' +
  		'Integer SignedInteger UnsignedInteger FloatingPoint Number ' +
  		'Signed Unsigned Float Array Comparable Ordered Env F32 F64 ' +
  		'I8 I16 I32 I64 I128 U8 U16 U32 U64 U128 Iterator Platform ' +
  		'Pointer Any None Bool Bytes StdStream String Stringable',
  		literal: 'true false'
  	};

  	var PONY_INTEGER = '';
  	var PONY_HEX = '';
  	var PONY_FLOAT = '';
  	var PONY_ESCAPE = '';

  	return {
  		lexemes: hljs.IDENT_RE,
  		keywords: PONY_KEYWORDS,
  		contains: [
          hljs.C_LINE_COMMENT_MODE,
          hljs.C_BLOCK_COMMENT_MODE,
          PONY_INTEGER,
          PONY_HEX,
          PONY_FLOAT,
          PONY_ESCAPE
  		]
  	};
  }