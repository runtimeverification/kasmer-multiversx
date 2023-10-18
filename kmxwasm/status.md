# Wasm + MultiversX function summarization

This project started as an attempt to prove that a simple sum-to-n contract does
what its name says. It turned out into a summarizer, so we should probably
investigate whether the summarizer project would work better here.

Below you can find the project’s status and the lessons learned while doing it.
At the end of the document there is a short description of how it works.

## Running

See README.md

## Lessons

The Haskell backend team prefers implementing pyk features instead of fixing
kore-repl, so, right now, someone doing proofs has to choose between an old
tool that has a lot of features (kore-repl), but is no longer supported, and a
new tool that is actively developed, and has a lot of potential, but currently
does not have that many debugging features (pyk).

Starting one’s own RPC server and using it from pyk may be a good way to get
some of the missing debugging features.

Simple step-by-step execution is rather slow for large configurations.
Part of it seems to be caused by the python part (most likely, the json
serialization, but I may be wrong), but the largest part is due to the Haskell
backend, most likely the current term + ceil simplification (the
“already simplified” and “known as defined” tags are internal to the backend
and are not exported in the json format).

## Time estimates
* Writing a simplification lemma
  * ~15 min
  * Frequency: Every now and then, I would estimate that each contract needs
  ~5 more lemmas for now, but I expect this to stop being needed after a while.
  Also, if we want summarizations that are easier to understand, we may have to
  also write rules for that.
* Implementing a builtin
  * 30 min to 1h, the time seems to decrease as I gain experience.
* Debugging
  * Every now and then one needs to investigate why a rule does not apply
    * Summarization rules
      * 1-2 hours of debugging
      * Frequency: once every ~2 changes to the way summarization rules are generated
    * Builtin rules
      * 30min - 1 hour
      * Frequency: once every ~5 builtin rules
  * Debugging random backend issues
    * 2-4 hours per issue
      * Frequency: Unclear, once per week maybe?
  * Running
    * Compilation (once per function attempt, see below for what that means)
      * 1-5 min
    * Taking a step
      * between 0.5 and 1 seconds for sum-to-n, around 1.5 minutes for Multisig.
  * Notes
    * Changing the configuration declaration, e.g. when implementing a new
      builtin, requires one to delete all checkpoints and restart the entire
      execution. The same is true when changing the configuration inside the
      summarizer script, e.g. by replacing a cell with a variable.
      Most other changes can resume execution from the last checkpoint, or,
      in the worst case, they require restarting the last function.
## Status
* The good
  * Can automatically summarize all functions of a contract that do not have
    loops or recursion - runs the function with symbolic inputs, symbolic
    memory and symbolic global variables.
    * Will take a lot of time if the total branching factor is large.
    * Works only if the builtins used are implemented/faked, throws an exception otherwise.
  * Produces a K rule for each function branch, describing how the function behaves for that case.
  * Saves checkpoints, so it can be stopped and restarted.
* The bad
  * Not implemented:
    * some builtins
    * Parallelism
    * Real MultiversX semantics
    * Branch merging
    * Loop invariants + summarization
    * Recursion invariants + summarization
    * Pretty-printing so that rules are easy to understand
    * Removing cells that are not important for human understanding
    * Using debug information
    * Function names
    * Global variable names
    * Names for memory chunks
    * Symbolic memory representation normalization.
* The ugly
  * Running a sum-to-n step (a wasm instruction may have multiple steps)
    takes between 0.5 and 1 seconds. Running a Multisig step takes ~1.5 minutes.
    * The multisig step can be optimized if we are willing to make the
      proof less rigorous, e.g. by removing most function definitions from the
      configuration.
  * The code is written as a prototype, would probably need some improvements
    if we would want to use it for actual summarization
    * Tests would be nice
  * The code does not have a limit on the number of branches that a function
    could have, so it may happen that someone starts it in the evening and
    leaves it running, only to find that the tool spent the entire night on a
    single function, generating huge quantities of data.
    * It’s probably easy to add.

## How it works

* Runs the contract with KRun, producing the initial configuration for all
  future summarization ().
* Replaces the memory with a sequence of function calls that produce the same
  Bytes object.
* Saves a checkpoint
* Indexes all function data
* Replaces some of the immutable cells with macros
* Replaces some of the mutable cells’ data with variables
* While there are functions that are not fully summarized
  * For each unsummarized function
    * Create a semantics that includes the rules for all the functions
      summarized until now
    * Load the checkpoint for the current function (if any)
    * Run the current function on symbolic inputs
    * Postpone summarization if execution reaches a call for an unsummarized
      function.
    * Stop all summarizations if execution reaches a call for an unimplemented
      builtin.
    * Give up on the current function if execution reaches a loop.
    * If everything was fine, create summarization rules for the current
      function
    * Both if everything was fine and if it was not, save a checkpoint for the
      current function’s execution.
