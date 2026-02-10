// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_simple_if.h"

void Vtop_simple_if___ctor_var_reset(Vtop_simple_if* vlSelf);

Vtop_simple_if::Vtop_simple_if(Vtop__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtop_simple_if___ctor_var_reset(this);
}

void Vtop_simple_if::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtop_simple_if::~Vtop_simple_if() {
}
