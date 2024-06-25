// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAutomateCompatible {
  /**
   * @notice method that is simulated by the automators to see if any work actually
   * needs to be performed. This method does does not actually need to be
   * executable, and since it is only ever simulated it can consume lots of gas.
   * @dev To ensure that it is never called, you may want to add the
   * cannotExecute modifier from AutomateBase to your implementation of this
   * method.
   * @param checkData specified in the task registration so it is always the
   * same for a registered task. This can easily be broken down into specific
   * arguments using `abi.decode`, so multiple tasks can be registered on the
   * same contract and easily differentiated by the contract.
   * @return taskNeeded boolean to indicate whether the automator should call
   * performtask or not.
   * @return performData bytes that the automator should call performtask with, if
   * task is needed. If you would like to encode data to decode later, try
   * `abi.encode`.
   */
  function checkTask(bytes calldata checkData) external returns (bool taskNeeded, bytes memory performData);

  /**
   * @notice method that is actually executed by the automators, via the registry.
   * The data returned by the checkTask simulation will be passed into
   * this method to actually be executed.
   * @dev The input to this method should not be trusted, and the caller of the
   * method should not even be restricted to any single registry. Anyone should
   * be able call it, and the input should be validated, there is no guarantee
   * that the data passed in is the performData returned from checkTask. This
   * could happen due to malicious automators, racing automators, or simply a state
   * change while the performTask transaction is waiting for confirmation.
   * Always validate the data passed in.
   * @param performData is the data which was passed back from the checkData
   * simulation. If it is encoded, it can easily be decoded into other types by
   * calling `abi.decode`. This data should not be trusted, and should be
   * validated against the contract's current state.
   */
  function performTask(bytes calldata performData) external;
}