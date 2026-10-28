using Test, RobustAndOptimalControl
@testset "prepared interconnection" begin
    P=named_ss(ss(tf(1.0,[1.,1.]));u=:u,y=:y)
    C=named_ss(ss(2.0);u=:e,y=:u)
    F=sumblock("e = r - y")
    systems=(P,C,F);wires=[:u=>:u,:y=>:y,:e=>:e]
    plan=RobustAndOptimalControl.prepare_connect(systems,wires;external_inputs=[:r],external_outputs=[:y])
    a=RobustAndOptimalControl.connect(plan,systems)
    b=RobustAndOptimalControl.connect(systems,wires;external_inputs=[:r],external_outputs=[:y],verbose=false)
    @test freqresp(a,[.1,1.,10.]) ≈ freqresp(b,[.1,1.,10.])
    @test a.u==b.u && a.y==b.y
end
