// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP_SIMPLE_IF_H_
#define VERILATED_VTOP_SIMPLE_IF_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop_simple_if final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ a;
    CData/*0:0*/ b;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop_simple_if(Vtop__Syms* symsp, const char* v__name);
    ~Vtop_simple_if();
    VL_UNCOPYABLE(Vtop_simple_if);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};

std::string VL_TO_STRING(const Vtop_simple_if* obj);

#endif  // guard
