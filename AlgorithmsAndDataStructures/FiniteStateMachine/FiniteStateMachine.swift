//
//  FiniteStateMachine.swift
//  FiniteStateMachine
//
//  Created by Sebastian Tleye on 23/02/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

@objcMembers
public class FiniteStateMachine: NSObject {

    private(set) var variables: Variables
    private(set) var currentState: State
    private(set) var initialState: State

    private var states: Set<State>
    private var symbols: Set<Symbol>
    private var transitions: [Transition]
    private var transitionTimer: Timer?

    public init(initialState: State, transitions: [Transition], variables: Variables = Variables()) {
        self.initialState = initialState
        self.states = [initialState]
        self.symbols = []
        for transition in transitions {
            self.states.insert(transition.origin)
            self.states.insert(transition.destination)
            self.symbols.insert(transition.input)
        }
        self.transitions = transitions
        self.currentState = initialState
        self.variables = variables
        super.init()
        self.variables.fsm = self
    }

    public func receive(input: Symbol) {
        for transition in transitions {
            if transition.origin == self.currentState && transition.input == input && transition.condition(self) {
                self.currentState = transition.destination
                transition.action(self)
                self.checkCurrentStateCondition()
                break
            }
        }
    }

    public func composeInParallel(with fsm: FiniteStateMachine) -> FiniteStateMachine {
        let initialState = State(state1: self.initialState, state2: fsm.initialState)
        var transitions: [Transition] = []
        for transitionSelf in self.transitions {
            for transitionParam in fsm.transitions {
                if transitionSelf.input == transitionParam.input {
                    transitions.append(createTransitionFrom(transition1: transitionSelf, and: transitionParam))
                }
            }
            if !fsm.symbols.contains(transitionSelf.input) {
                for state in fsm.states {
                    let transition = Transition(from: State(state1: transitionSelf.origin, state2: state),
                                                to: State(state1: transitionSelf.destination, state2: state),
                                                through: transitionSelf.input,
                                                condition: transitionSelf.condition,
                                                action: transitionSelf.action)
                    transitions.append(transition)
                }
            }
        }
        for transitionFsm in fsm.transitions {
            if !self.symbols.contains(transitionFsm.input) {
                for state in self.states {
                    let transition = Transition(from: State(state1: state, state2: transitionFsm.origin),
                                                to: State(state1: state, state2: transitionFsm.destination),
                                                through: transitionFsm.input,
                                                condition: transitionFsm.condition,
                                                action: transitionFsm.action)
                    transitions.append(transition)
                }
            }
        }
        return FiniteStateMachine(initialState: initialState,
                                  transitions: transitions,
                                  variables: self.variables.merge(with: fsm.variables))
    }

    @objc private func checkCurrentStateCondition() {
        if let condition = self.currentState.condition, !condition.isSatisfied((self.variables)) {
            self.leaveCurrentState()
        }
    }

    private func leaveCurrentState() {
        for transition in transitions where transition.origin == self.currentState {
            //the if statement below may not correct,
            //the action in the transition may change the variables so it may be fine to take a transition to the same state in those cases
            if transition.destination != transition.origin {
                if transition.condition(self) {
                    self.receive(input: transition.input)
                    return
                }
            }
        }
        //DEADLOCK
    }

    private func createTransitionFrom(transition1: Transition, and transition2: Transition) -> Transition {
        let action = { (fsm: FiniteStateMachine) in
            transition1.action(fsm)
            transition2.action(fsm)
        }
        let condition = { (fsm: FiniteStateMachine) in
            return transition1.condition(fsm) && transition2.condition(fsm)
        }
        return Transition(from: State(state1: transition1.origin, state2: transition2.origin),
                          to: State(state1: transition1.destination, state2: transition2.destination),
                          through: transition1.input,
                          condition: condition,
                          action: action)
    }

}

// Structs and Aliases
extension FiniteStateMachine {

    public typealias Symbol = Int
    typealias Event = (Transition) -> Void

    public class State: Hashable {

        public struct Condition {

            private var condition: ((Variables) -> Bool)

            public static func createFrom(_ condition1: Condition?, and condition2: Condition?) -> Condition {
                return Condition(condition: { variables in
                    (condition1?.isSatisfied(variables) ?? true) && (condition2?.isSatisfied(variables) ?? true)
                })
            }

            public static func allwaysTrue() -> Condition {
                return Condition { (variables) -> Bool in return true }
            }

            public static func timer(_ name: String, is comparator: @escaping (Int, Int) -> Bool, than value: Int) -> Condition {
                return Condition(condition: { variables in comparator(variables.timerValueFor(name), value) })
            }

            public static func variable<T: Comparable>(_ name: String, is comparator: @escaping (T, T) -> Bool, than value: T) -> Condition {
                return Condition(condition: { variables in comparator(variables.valueFor(name) as! T, value) })
            }

            public func isSatisfied(_ variables: Variables) -> Bool {
                return self.condition(variables)
            }

        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public static func == (lhs: FiniteStateMachine.State, rhs: FiniteStateMachine.State) -> Bool {
            return lhs.id == rhs.id && lhs.state1 == rhs.state1 && lhs.state2 == rhs.state2
        }

        private(set) var id: String
        private(set) var condition: Condition?
        private(set)var name: String

        private var state1: State?
        private var state2: State?

        public init(_ id: String, _ name: String, condition: Condition? = nil) {
            self.id = id
            self.name = name
            self.condition = condition
        }

        public convenience init(_ id: String) {
            self.init(id, id, condition: nil)
        }

        public convenience init(_ id: String, condition: Condition?) {
            self.init(id, id, condition: condition)
        }

        public convenience init(state1: State, state2: State) {
            let condition = Condition.createFrom(state1.condition, and: state2.condition)
            let newId = state1.id + ", " + state2.id
            let newName = state1.name + ", " + state2.name
            self.init(newId, newName, condition: condition )
            self.state1 = state1
            self.state2 = state2
        }

        public func contains(_ state: State) -> Bool {
            if self.state1 == nil && self.state2 == nil { return false }
            if self.state1 == state { return true }
            if self.state2 == state { return true }
            return (self.state1?.contains(state) ?? false) || (self.state2?.contains(state) ?? false)
        }
    }

    public struct Transition: Hashable {

        public func hash(into hasher: inout Hasher) {
            hasher.combine(origin)
            hasher.combine(input)
            hasher.combine(destination)
        }

        public static func == (lhs: FiniteStateMachine.Transition, rhs: FiniteStateMachine.Transition) -> Bool {
            return lhs.origin == rhs.origin && lhs.input == rhs.input && lhs.destination == rhs.destination
        }

        public var origin: State
        public var input: Symbol
        public var destination: State
        public var condition: ((FiniteStateMachine) -> Bool)
        public var action: ((FiniteStateMachine) -> Void)

        public init(from origin: State,
             to destination: State,
             through input: Symbol,
             condition: @escaping ((FiniteStateMachine) -> Bool) = { _ in true },
             action: @escaping ((FiniteStateMachine) -> Void) = { _ in }) {
            self.origin = origin
            self.input = input
            self.destination = destination
            self.condition = condition
            self.action = action
        }

        public init(_ from: String,
             _ to: String,
             _ through: Symbol,
             condition: @escaping ((FiniteStateMachine) -> Bool) = { _ in true },
             action: @escaping ((FiniteStateMachine) -> Void) = { _ in }) {
            self.init(from: State(from), to: State(to), through: through, condition: condition, action: action)
        }
    }

    public class Variables {

        weak var fsm: FiniteStateMachine?
        
        private var timers: [String: Int] = [:]
        private var variables: [String: Any] = [:]
        private var timer: Timer?

        public init(_ values: (String, Any)...) {
            for value in values {
                self.variables[value.0] = value.1
            }
        }

        public func valueFor(_ name: String) -> Any? {
            return self.variables[name]
        }

        public func intValueFor(_ name: String) -> Int {
            return self.valueFor(name) as! Int
        }

        public func stringValueFor(_ name: String) -> String {
            return self.valueFor(name) as! String
        }

        public func timerValueFor(_ name: String) -> Int {
            return self.timers[name]!
        }

        public func set(value: Any, to name: String) {
            self.variables[name] = value
            fsm?.checkCurrentStateCondition()
        }

        public func resetTimer(_ name: String) {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(incrementTimeOneSecond),
                                             userInfo: nil,
                                             repeats: true)
            }
            timers[name] = 0
        }

        fileprivate func merge(with variables: Variables) -> Variables {
            let result: Variables = variables
            for (name, value) in self.variables {
                result.set(value: value, to: name)
            }
            return result
        }

        @objc private func incrementTimeOneSecond() {
            for key in timers.keys {
                timers[key] = timers[key]! + 1
            }
            fsm?.checkCurrentStateCondition()
        }

    }

}
