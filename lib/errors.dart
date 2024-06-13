// ignore: camel_case_types

import 'package:flutter/material.dart';

/// A subsystem for storing errors that may occur during an operation (function call).
abstract class Errors
{
	int _errors = 0;

	/// Adds `error`.
  ///
  /// If `error` already exists, nothing will happen.
  void add(int error)
  {
    _errors |= error;
  }

	/// Checks if any error occurred
	bool hasAny()
	{
		return _errors != 0;
	}

	@protected
  /// Checks if [error] occurred
	bool has(int error)
	{
		return (_errors & error) != 0;
	}
}
