#include "Vtop.h"
#include "verilated.h"
#include <cstdint>
#include <iostream>

static vluint64_t main_time = 0;
double sc_time_stamp() {return main_time;}

static void tick(Vtop* dut) {
    dut->clk = 0;
    dut-> eval();
    main_time++;

    dut->clk = 1;
    dut-> eval();
    main_time++;
}

int main(int argc, char** argv){
    Verilated::commandArgs(argc,argv);
    Vtop* dut = new Vtop;
    
    //Reset-like init
    dut->valid=0;
    dut->ready=0;
    dut->addr=0;
    dut->wdata=0;

    //Run a few cycles
    for (int i = 0; i < 5; i++) tick(dut);
    
    //WRITE addr=0x100f, data = 0xdeadbeef
    dut->valid=1;
    dut->is_write=1;
    dut->addr=0x100;
    dut->wdata = 0xdeadbeef;

    //wait one cycle
    tick(dut);

    dut->valid=0;
    tick(dut);

    //READ: addr=0x100;
    dut->valid=1;
    dut->is_write=0;
    dut->addr=0x1220;

    tick(dut);
    dut->valid=0;
    tick(dut);

    std::cout << "Read data seen by host : 0x" << std::hex << (uint32_t)dut->rdata << std::dec << "\n";

    //finish
    
    for (int i =0; i < 5; i++) tick(dut);

    delete dut;
    return 0;
}