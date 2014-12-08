function mpc = case_ieee9
%CASE_IEEE9
%  Please see 'help caseformat' for details on the case file format.
%  This data was converted from IEEE Common Data Format
%  (d_009ieee.cf) on 27-May-2014 by cdf2matp, rev. 1.25
%  See end of file for warnings generated during conversion.
%
% 05/27/14 PSAT ARCHIVE         100.00 2014 S 9-Bus 9-Line System                                                                

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	3	0	0	0	0	1	1.04	0	100	0	1.06	0.94;
	2	2	0	0	0	0	1	1.025	9.28	100	0	1.06	0.94;
	3	2	0	0	0	0	1	1.025	4.664	100	0	1.06	0.94;
	4	1	0	0	0	0	1	1.025	-2.216	100	0	1.06	0.94;
	5	1	125	50	0	0	1	0.995	-3.988	100	0	1.06	0.94;
	6	1	90	30	0	0	1	1.012	-3.687	100	0	1.06	0.94;
	7	1	0	0	0	0	1	1.025	3.72	100	0	1.06	0.94;
	8	1	100	35	0	0	1	1.015	0.728	100	0	1.06	0.94;
	9	1	0	0	0	0	1	1.032	1.967	100	0	1.06	0.94;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	71.641	0	9999	-9999	1.04	100	1	9800.5	0	0	0	0	0	0	0	0	0	0	0	0;
	2	163	0	9999	-9999	1.025	100	1	2630	0	0	0	0	0	0	0	0	0	0	0	0;
	3	85	0	9999	-9999	1.025	100	1	1850	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	4	1	0	0.0576	0	9900	0	0	0	0	1	-360	360;
	7	2	0	0.0625	0	9900	0	0	0	0	1	-360	360;
	9	3	0	0.0586	0	9900	0	0	0	0	1	-360	360;
	7	8	0.0085	0.072	0.149	9900	0	0	0	0	1	-360	360;
	9	8	0.0119	0.1008	0.209	9900	0	0	0	0	1	-360	360;
	7	5	0.032	0.161	0.306	9900	0	0	0	0	1	-360	360;
	9	6	0.039	0.17	0.358	9900	0	0	0	0	1	-360	360;
	5	4	0.01	0.085	0.176	9900	0	0	0	0	1	-360	360;
	6	4	0.017	0.092	0.158	9900	0	0	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	2	1	0;
	2	0	0	2	1	0;
	2	0	0	2	1	0;
];

% bus names
mpc.busnames = [
	'BUS-1   100'
	'BUS-2   100'
	'BUS-3   100'
	'BUS-4   100'
	'BUS-5   100'
	'BUS-6   100'
	'BUS-7   100'
	'BUS-8   100'
	'BUS-9   100'
];

nBus = size(mpc.bus,1);
nGen = size(mpc.gen,1);
nVar = 2*nBus + 2*nGen;
mpc.N = sparse(2*nBus+nGen+1:nVar,2*nBus+nGen+1:nVar,ones(1,nGen));
mpc.Cw = sparse(nVar,1);
mpc.H = speye(nVar,nVar);

% Warnings from cdf2matp conversion:
%
% ***** check the title format in the first line of the cdf file.
% ***** Insufficient generation, setting Pmax at slack bus (bus 1) to 98.5
% ***** MVA limit of branch 4 - 1 not given, set to 9900
% ***** MVA limit of branch 7 - 2 not given, set to 9900
% ***** MVA limit of branch 9 - 3 not given, set to 9900
% ***** MVA limit of branch 7 - 8 not given, set to 9900
% ***** MVA limit of branch 9 - 8 not given, set to 9900
% ***** MVA limit of branch 7 - 5 not given, set to 9900
% ***** MVA limit of branch 9 - 6 not given, set to 9900
% ***** MVA limit of branch 5 - 4 not given, set to 9900
% ***** MVA limit of branch 6 - 4 not given, set to 9900
