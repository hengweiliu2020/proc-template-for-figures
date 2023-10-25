proc means data=sashelp.class;
	var height;
	output out=out1(drop=_type_ _freq_) n=n mean=mean std=std min=min max=max;
run;

proc transpose data=out1 out=out2;
run;

data _null_;
	set out2 end=eof;
	i+1;
	call symput(compress('name'||put(i, best.)), trim(left(_name_)));
	call symput(compress('val'||put(i, best.)), trim(left(put(col1,5.1))));

	if eof then
		call symput('tot', trim(Left(put(_n_, best.))));
run;

%macro create_histplot;

	proc template;
		define statgraph histplot;
			begingraph;

layout lattice / columndatarange=union rowweights=(0.7 0.3) rowgutter=0 rows=2;
				layout overlay/yaxisopts=(griddisplay=on);
					histogram height;
				endlayout;
					layout gridded/rows=2 columns=&tot
						autoalign=( topright) border=true
						opaque=true backgroundcolor=GraphWalls:color;

						%do i=1 %to &tot;
							entry halign=left "&&name&i";
						%end;

						%do i=1 %to &tot;
							entry halign=left "&&val&i";
						%end;

					
				   endlayout;
				   endlayout;
			endgraph;
		end;
	run;

%mend;

%create_histplot;

proc sgrender data=sashelp.class template=histplot;
run;
