using Tk
using Winston
using Spiketrains

type NavigationState
    state::Integer
end

type NavigationControls
    state
end

function visualize(X)
    navstate = NavigationState(1)
    win = Toplevel("Visualize",400,200)
    fwin = Frame(win)
    pack(fwin, expand=true, fill="both")
    c = Canvas(fwin, 300,200)
    grid(c,1,1, sticky="nsew")
    fctrls = Frame(fwin)
    grid(fctrls,2,1,sticky="sw",padx=5,pady=5)
    grid_columnconfigure(fwin,1,weight=1)
    grid_rowconfigure(fwin,1,weight=1)
    prev = Button(fctrls,"Prev")
    grid(prev,1,1)
    en = Entry(fctrls, width=5)
    navctrls = NavigationControls(en)
    grid(en,1,2)
    set_value(en,string(navstate.state))
    nxt = Button(fctrls,"Next")
    grid(nxt,1,3)
    bind(prev, "command", path -> plottest(c,navstate,navctrls,X,navstate.state-1))
    bind(nxt, "command", path -> plottest(c,navstate, navctrls, X,navstate.state+1))
    bind(en, "<Return>", path -> updatef(navstate,navctrls,c,X))
    
end

function updatef(navstate::NavigationState, navctrls::NavigationControls,c,X)
    navstate.state = int(get_value(navctrls.state))
    plottest(c,navstate,navctrls,X,navstate.state)
end

function plottest(c,navstate::NavigationState,navctrls::NavigationControls,X,i::Integer)
    if i <= length(X) && i > 0
        p = FramedPlot()
        plot!(p,X,i)
        Winston.display(c,p)
        reveal(c)
        Tk.update()
        navstate.state = i
        set_value(navctrls.state, string(i))
    end
end

function plottest(c,a)
    #test
    x = linspace(0.0,10.0,1001)
    y = sin(a*x)
    p = FramedPlot()
    add(p,Curve(x,y,"color","red"))
    Winston.display(c,p)
    reveal(c)
    Tk.update()
end