const std = @import("std");
const ValType = @import("../valtype.zig").ValType;
const VirtualMachine = @import("../vm.zig").VirtualMachine;
const WasmError = @import("../vm.zig").WasmError;
const Instance = @import("../instance.zig").Instance;
const FuncType = @import("../module.zig").FuncType;

pub const Function = struct {
    params: []const ValType,
    results: []const ValType,
    subtype: union(enum) {
        function: struct {
            locals_count: usize,
            start: usize,
            required_stack_space: usize,
            instance: usize,
        },
        host_function: struct {
            func: *const fn (*VirtualMachine) WasmError!void,
        },
    },

    pub fn checkSignatures(self: Function, b: FuncType) !void {
        if (self.params.len != b.params.len) return error.MismatchedSignatures;
        if (self.results.len != b.results.len) return error.MismatchedSignatures;

        for (self.params) |p_a, i| {
            if (p_a != b.params[i]) return error.MismatchedSignatures;
        }

        for (self.results) |r_a, i| {
            if (r_a != b.results[i]) return error.MismatchedSignatures;
        }
    }
};
