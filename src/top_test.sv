module top;
    simple_if s();
    initial begin
        s.a = 0;
        #1;
        s.a = 1;
        #1;
        $display("s.b = %0d", s.b);
        #1;
        $finish;
    end

    simple_if b();
    initial begin
        b.a = 0;
        #1
        #1
        $display("b.a = %0d", b.b);
        $finish;
    end



    use_if u0(.s(s));
    use_if u1(.s(b));
endmodule
