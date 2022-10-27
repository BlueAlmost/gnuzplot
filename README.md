# gnuzplot
***zig*** module code for data plotting using gnuplot (hence the name here with a "z" inserted, yielding gnu**z**plot)

* <ins>basic idea:</ins>    allow plotting of data vectors from within zig (pipe into child process of gnuplot)

* <ins>simple demo:</ins>    compile and run **examples** found in the example directory, or run zig tests

* <ins>motivation:</ins>    visualization of vectors or other data while they undergo manipulation within zig

* <ins>requires:</ins>    local installation of gnuplot (see www.gnuplot.info)

* <ins>note:</ins>    has been developed/tested in linux environment (Devuan), functionality on Windows not tried.

------------------

* <ins>gallery of figures with</ins> gnuzplot_ex:

![fig_1](https://user-images.githubusercontent.com/100024520/177419277-39fe3467-a5f8-4241-8f89-823acdc846f3.png)

    ```
    // single plot
    try plt.grid_on();
    try plt.title("A simple signal from JSON data file");
    try plt.plot( .{plot_data.s, "title 'sin pulse' with lines ls 5 lw 1"} );
    ```
  
------------------

![fig_2](https://user-images.githubusercontent.com/100024520/177419281-191554f6-aa3c-4f21-9772-75adbcbfab8a.png)

    ```
    // single plot with marker
    try plt.grid_on();
    try plt.title("now with line and point");
    try plt.plot( .{plot_data.c, "title 'sin pulse' with linespoints ls 3 lw 2 pt 7 ps 2"} );
    ```

------------------

![fig_3](https://user-images.githubusercontent.com/100024520/177419283-c919e99a-30d3-4a9c-8113-9646d21d352b.png)

    ```
    // double plot
    try plt.grid_off();
    try plt.title("Two other signals with transparency");
    try plt.plot(.{
        plot_data.s,"title 'sin' with lines ls 14 lw 2",
        plot_data.n,"title 'sin in noise' with lines ls 25 lw 2"
    });
    ```
    
------------------   

![fig_4](https://user-images.githubusercontent.com/100024520/177419285-aa173356-edcc-432a-9260-b75cd1b738f8.png)

    ```
    // x vs. y line plot
    try plt.title("x vs y line plot");
    try plt.plotxy(.{
        plot_data.spx1,plot_data.spy1,"title 'x' with linespoints lw 1 pt 9 ps 2.3",
        plot_data.spx2,plot_data.spy2,"title 'x' with linespoints lw 2 pt 7 ps 2.3",
    });
    ```
    
 ------------------

![fig_5](https://user-images.githubusercontent.com/100024520/177419286-c9e26ccb-3a3e-4b9d-9af7-a19ecfdd6451.png)

    ```
    // x vs. y scatter plot
    try plt.title("x vs y scatter plot with transparency");
    try plt.plotxy(.{plot_data.bx,plot_data.by,"title 'x' with points ls 28 pt 7 ps 5"});
    ```

 ------------------

![fig_6](https://user-images.githubusercontent.com/100024520/177419291-99876af8-e110-48a9-9208-135c1bcaf224.png)

    ```
    // simple bar plot
    try plt.grid_on();
    try plt.title("bar plot");
    try plt.bar( .{plot_data.x, 0.75, "title 'x' ls 7 "} );
    ```
    
 ------------------
   
![fig_7](https://user-images.githubusercontent.com/100024520/177419293-99b3bd51-bf6a-4808-aa50-bd5efd28cc38.png)

    ```
    // shared bar plot 
    try plt.grid_on();
    try plt.title("shared bar plot with three vectors");
    try plt.bar( .{
        plot_data.x, 0.5, "title 'x' ls 33 ",
        plot_data.y, 0.5, "title 'y' ls 44 ",
        plot_data.z, 0.5, "title 'z' ls 55 "
    } );
    ```
    
 ------------------ 

* <ins>emphasis:</ins>    focus on plotting of **DATA** directly from within zig programs, typically gnuplot works either in an interactive mode, or scripted mode using data files.  

gnu**z**plot pipes data directly to gnuplot using efficient wrappers for direct data plot (no need for intermediate files).  A number of most common wrappers are implemented, but virtually any gnuplot command can be used by virtue of a **cmd** call from zig.  

Plotting defaults to screen display, but creating output image files such as png is simple (pngcairo terminal setting is recommended in that case.)
