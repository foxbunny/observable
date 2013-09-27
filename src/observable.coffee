# # Basic observable values implementation
#
# This is a lightweight alternative to Backbone models for use when the full
# model is too cumbersome.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
  else
    if typeof module is 'object' and module.exports
      (factory) ->
        module.exports = factory()
    else
      (factory) ->
        root.Observable = factory()
)(this)

define () ->
  # ## `Observable(initial)`
  #
  # Constructor for creating observable values.
  #
  # The `initial` value is the inital height of the object.
  #
  # Example:
  #
  #     var observer;
  #     var observable;
  #
  #     observer = function (newVal, oldVal) {
  #       console.log('Value has changed from ' + oldVal + ' to ' + newVal);
  #     };
  #
  #     observable = new Observable(12);
  #     observable.watch(observer);
  #     observable.set(9);
  #
  #     // logs: "Value has changed from 12 to 9"
  #
  class Observable
    constructor: (initial) ->
      if not @ instanceof Observable
        return new Observable(initial)
      @previousValue = undefined
      @value = initial
      @observers = []

    # ## `Observable.prototype.set(v)`
    #
    # Sets the value of the observable to `v` and  triggers observers.
    #
    # Note that this method will not do anything if the value to be set is the
    # same value as the current one.
    #
    set: (v) ->
      return if v is @value  # Hasn't chaged
      @previousValue = @value
      @value = v
      for fn in @observers
        fn.call(@, @value, @previousValue)

    # ## `Observable.prototype.get()`
    #
    # Returns the current value.
    #
    get: () ->
      @value

    # ### `Observer.prototype.watch(callback)
    #
    # Binds a `callback` function to be executed whenever the value changes
    # changes. The function has the following signature:
    #
    #     function (newVal, oldVal) { }
    #
    # The callback function is bound to the observable object so you can
    #
    watch: (cb) ->
      return if typeof cb isnt 'function'
      @observers.push(cb)

