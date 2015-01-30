function mpc = case_ieee39
%CASE_IEEE39
%  Please see 'help caseformat' for details on the case file format.
%  This data was converted from IEEE Common Data Format
%  (039ieee.DAT) on 24-Nov-2014 by cdf2matp, rev. 1.25
%  See end of file for warnings generated during conversion.
%
% 00/00/01                      100.0  0    0 0                                                                                                                                                                                                                                                             

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	1	0	0	0	0	1	1.047	-9.57	100	1	1.06	0.94;
	2	1	0	0	0	0	1	1.049	-7.011	100	1	1.06	0.94;
	3	1	322	2.4	0	0	1	1.03	-9.858	100	1	1.06	0.94;
	4	1	500	184	0	0	1	1.003	-10.65	100	1	1.06	0.94;
	5	1	0	0	0	0	1	1.005	-9.468	100	1	1.06	0.94;
	6	1	0	0	0	0	1	1.007	-8.766	100	1	1.06	0.94;
	7	1	233.8	84	0	0	1	0.996	-10.97	100	1	1.06	0.94;
	8	1	522	176	0	0	1	0.995	-11.47	100	1	1.06	0.94;
	9	1	0	0	0	0	1	1.028	-11.29	100	1	1.06	0.94;
	10	1	0	0	0	0	1	1.017	-6.381	100	1	1.06	0.94;
	11	1	0	0	0	0	1	1.012	-7.195	100	1	1.06	0.94;
	12	1	8.5	88	0	0	1	1	-7.21	100	1	1.06	0.94;
	13	1	0	0	0	0	1	1.014	-7.095	100	1	1.06	0.94;
	14	1	0	0	0	0	1	1.011	-8.764	100	1	1.06	0.94;
	15	1	320	153	0	0	1	1.015	-9.18	100	1	1.06	0.94;
	16	1	329	32.3	0	0	1	1.032	-7.776	100	1	1.06	0.94;
	17	1	0	0	0	0	1	1.034	-8.774	100	1	1.06	0.94;
	18	1	158	30	0	0	1	1.031	-9.615	100	1	1.06	0.94;
	19	1	0	0	0	0	1	1.05	-3.152	100	1	1.06	0.94;
	20	1	680	103	0	0	1	0.991	-4.563	100	1	1.06	0.94;
	21	1	274	115	0	0	1	1.032	-5.371	100	1	1.06	0.94;
	22	1	0	0	0	0	1	1.05	-0.923	100	1	1.06	0.94;
	23	1	247.5	84.6	0	0	1	1.045	-1.122	100	1	1.06	0.94;
	24	1	308.6	-92.2	0	0	1	1.037	-7.656	100	1	1.06	0.94;
	25	1	224	47.2	0	0	1	1.057	-5.649	100	1	1.06	0.94;
	26	1	139	17	0	0	1	1.052	-6.905	100	1	1.06	0.94;
	27	1	281	75.5	0	0	1	1.037	-8.917	100	1	1.06	0.94;
	28	1	206	27.6	0	0	1	1.05	-3.394	100	1	1.06	0.94;
	29	1	283.5	26.9	0	0	1	1.05	-0.635	100	1	1.06	0.94;
	30	2	0	0	0	0	1	1.047	-4.591	100	1	1.06	0.94;
	31	3	9.2	4.6	0	0	1	0.982	0	100	1	1.06	0.94;
	32	2	0	0	0	0	1	0.983	1.6155	100	1	1.06	0.94;
	33	2	0	0	0	0	1	0.997	2.0646	100	1	1.06	0.94;
	34	2	0	0	0	0	1	1.012	0.6262	100	1	1.06	0.94;
	35	2	0	0	0	0	1	1.049	4.0369	100	1	1.06	0.94;
	36	2	0	0	0	0	1	1.063	6.7295	100	1	1.06	0.94;
	37	2	0	0	0	0	1	1.027	1.1354	100	1	1.06	0.94;
	38	2	0	0	0	0	1	1.026	6.4281	100	1	1.06	0.94;
	39	2	1104	250	0	0	1	1.03	-11.1	100	1	1.06	0.94;
];

mpc.bus(:,12) = 1.1*ones(39,1);
mpc.bus(:,13) = 0.9*ones(39,1);

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	30	250	144.9193	999900	-99990	1.0475	100	1	350	0	0	0	0	0	0	0	0	0	0	0	0;
	31	572.8349	207.0362	999900	-99990	0.982	100	1	1145.11	0	0	0	0	0	0	0	0	0	0	0	0;
	32	650	205.7308	999900	-99990	0.9831	100	1	750	0	0	0	0	0	0	0	0	0	0	0	0;
	33	632	108.9353	999900	-99990	0.9972	100	1	732	0	0	0	0	0	0	0	0	0	0	0	0;
	34	508	166.9861	999900	-99990	1.0123	100	1	608	0	0	0	0	0	0	0	0	0	0	0	0;
	35	650	211.1116	999900	-99990	1.0493	100	1	750	0	0	0	0	0	0	0	0	0	0	0	0;
	36	560	100.4374	999900	-99990	1.0635	100	1	660	0	0	0	0	0	0	0	0	0	0	0	0;
	37	540	0.64734	999900	-99990	1.0278	100	1	640	0	0	0	0	0	0	0	0	0	0	0	0;
	38	830	22.65884	999900	-99990	1.0265	100	1	930	0	0	0	0	0	0	0	0	0	0	0	0;
	39	1000	87.8826	999900	-99990	1.03	100	1	1100	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	2	1	0.0035	0.0411	0.6987	9900	0	0	0	0	1	-360	360;
	39	1	0.001	0.025	0.75	9900	0	0	0	0	1	-360	360;
	3	2	0.0013	0.0151	0.2572	9900	0	0	0	0	1	-360	360;
	25	2	0.007	0.0086	0.146	9900	0	0	0	0	1	-360	360;
	4	3	0.0013	0.0213	0.2214	9900	0	0	0	0	1	-360	360;
	18	3	0.0011	0.0133	0.2138	9900	0	0	0	0	1	-360	360;
	5	4	0.0008	0.0128	0.1342	9900	0	0	0	0	1	-360	360;
	14	4	0.0008	0.0129	0.1382	9900	0	0	0	0	1	-360	360;
	6	5	0.0002	0.0026	0.0434	9900	0	0	0	0	1	-360	360;
	8	5	0.0008	0.0112	0.1476	9900	0	0	0	0	1	-360	360;
	7	6	0.0006	0.0092	0.113	9900	0	0	0	0	1	-360	360;
	11	6	0.0007	0.0082	0.1389	9900	0	0	0	0	1	-360	360;
	8	7	0.0004	0.0046	0.078	9900	0	0	0	0	1	-360	360;
	9	8	0.0023	0.0363	0.3804	9900	0	0	0	0	1	-360	360;
	39	9	0.001	0.025	1.2	9900	0	0	0	0	1	-360	360;
	11	10	0.0004	0.0043	0.0729	9900	0	0	0	0	1	-360	360;
	13	10	0.0004	0.0043	0.0729	9900	0	0	0	0	1	-360	360;
	14	13	0.0009	0.0101	0.1723	9900	0	0	0	0	1	-360	360;
	15	14	0.0018	0.0217	0.366	9900	0	0	0	0	1	-360	360;
	16	15	0.0009	0.0094	0.171	9900	0	0	0	0	1	-360	360;
	17	16	0.0007	0.0089	0.1342	9900	0	0	0	0	1	-360	360;
	19	16	0.0016	0.0195	0.304	9900	0	0	0	0	1	-360	360;
	21	16	0.0008	0.0135	0.2548	9900	0	0	0	0	1	-360	360;
	24	16	0.0003	0.0059	0.068	9900	0	0	0	0	1	-360	360;
	18	17	0.0007	0.0082	0.1319	9900	0	0	0	0	1	-360	360;
	27	17	0.0013	0.0173	0.3216	9900	0	0	0	0	1	-360	360;
	22	21	0.0008	0.014	0.2565	9900	0	0	0	0	1	-360	360;
	23	22	0.0006	0.0096	0.1846	9900	0	0	0	0	1	-360	360;
	24	23	0.0022	0.035	0.361	9900	0	0	0	0	1	-360	360;
	26	25	0.0032	0.0323	0.513	9900	0	0	0	0	1	-360	360;
	27	26	0.0014	0.0147	0.2396	9900	0	0	0	0	1	-360	360;
	28	26	0.0043	0.0474	0.7802	9900	0	0	0	0	1	-360	360;
	29	26	0.0057	0.0625	1.029	9900	0	0	0	0	1	-360	360;
	29	28	0.0014	0.0151	0.249	9900	0	0	0	0	1	-360	360;
	12	11	0.0016	0.0435	0	9900	0	0	1.006	0	1	-360	360;
	12	13	0.0016	0.0435	0	9900	0	0	1.006	0	1	-360	360;
	6	31	0	0.025	0	9900	0	0	1.07	0	1	-360	360;
	10	32	0	0.02	0	9900	0	0	1.07	0	1	-360	360;
	19	33	0.0007	0.0142	0	9900	0	0	1.07	0	1	-360	360;
	20	34	0.0009	0.018	0	9900	0	0	1.009	0	1	-360	360;
	22	35	0	0.0143	0	9900	0	0	1.025	0	1	-360	360;
	23	36	0.0005	0.0272	0	9900	0	0	1	0	1	-360	360;
	25	37	0.0006	0.0232	0	9900	0	0	1.025	0	1	-360	360;
	2	30	0	0.0181	0	9900	0	0	1.025	0	1	-360	360;
	29	38	0.0008	0.0156	0	9900	0	0	1.025	0	1	-360	360;
	19	20	0.0007	0.0138	0	9900	0	0	1.06	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	3	0.04	20	0;
	2	0	0	3	0.0174570369	20	0;
	2	0	0	3	0.0153846154	20	0;
	2	0	0	3	0.0158227848	20	0;
	2	0	0	3	0.0196850394	20	0;
	2	0	0	3	0.0153846154	20	0;
	2	0	0	3	0.0178571429	20	0;
	2	0	0	3	0.0185185185	20	0;
	2	0	0	3	0.0120481928	20	0;
	2	0	0	3	0.01	20	0;
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
	'BUS-10  100'
	'BUS-11  100'
	'BUS-12  100'
	'BUS-13  100'
	'BUS-14  100'
	'BUS-15  100'
	'BUS-16  100'
	'BUS-17  100'
	'BUS-18  100'
	'BUS-19  100'
	'BUS-20  100'
	'BUS-21  100'
	'BUS-22  100'
	'BUS-23  100'
	'BUS-24  100'
	'BUS-25  100'
	'BUS-26  100'
	'BUS-27  100'
	'BUS-28  100'
	'BUS-29  100'
	'BUS-30  100'
	'BUS-31  100'
	'BUS-32  100'
	'BUS-33  100'
	'BUS-34  100'
	'BUS-35  100'
	'BUS-36  100'
	'BUS-37  100'
	'BUS-38  100'
	'BUS-39  100'
];

% Warnings from cdf2matp conversion:
%
% ***** check the title format in the first line of the cdf file.
% ***** Insufficient generation, setting Pmax at slack bus (bus 31) to 1145.11
% ***** MVA limit of branch 2 - 1 not given, set to 9900
% ***** MVA limit of branch 39 - 1 not given, set to 9900
% ***** MVA limit of branch 3 - 2 not given, set to 9900
% ***** MVA limit of branch 25 - 2 not given, set to 9900
% ***** MVA limit of branch 4 - 3 not given, set to 9900
% ***** MVA limit of branch 18 - 3 not given, set to 9900
% ***** MVA limit of branch 5 - 4 not given, set to 9900
% ***** MVA limit of branch 14 - 4 not given, set to 9900
% ***** MVA limit of branch 6 - 5 not given, set to 9900
% ***** MVA limit of branch 8 - 5 not given, set to 9900
% ***** MVA limit of branch 7 - 6 not given, set to 9900
% ***** MVA limit of branch 11 - 6 not given, set to 9900
% ***** MVA limit of branch 8 - 7 not given, set to 9900
% ***** MVA limit of branch 9 - 8 not given, set to 9900
% ***** MVA limit of branch 39 - 9 not given, set to 9900
% ***** MVA limit of branch 11 - 10 not given, set to 9900
% ***** MVA limit of branch 13 - 10 not given, set to 9900
% ***** MVA limit of branch 14 - 13 not given, set to 9900
% ***** MVA limit of branch 15 - 14 not given, set to 9900
% ***** MVA limit of branch 16 - 15 not given, set to 9900
% ***** MVA limit of branch 17 - 16 not given, set to 9900
% ***** MVA limit of branch 19 - 16 not given, set to 9900
% ***** MVA limit of branch 21 - 16 not given, set to 9900
% ***** MVA limit of branch 24 - 16 not given, set to 9900
% ***** MVA limit of branch 18 - 17 not given, set to 9900
% ***** MVA limit of branch 27 - 17 not given, set to 9900
% ***** MVA limit of branch 22 - 21 not given, set to 9900
% ***** MVA limit of branch 23 - 22 not given, set to 9900
% ***** MVA limit of branch 24 - 23 not given, set to 9900
% ***** MVA limit of branch 26 - 25 not given, set to 9900
% ***** MVA limit of branch 27 - 26 not given, set to 9900
% ***** MVA limit of branch 28 - 26 not given, set to 9900
% ***** MVA limit of branch 29 - 26 not given, set to 9900
% ***** MVA limit of branch 29 - 28 not given, set to 9900
% ***** MVA limit of branch 12 - 11 not given, set to 9900
% ***** MVA limit of branch 12 - 13 not given, set to 9900
% ***** MVA limit of branch 6 - 31 not given, set to 9900
% ***** MVA limit of branch 10 - 32 not given, set to 9900
% ***** MVA limit of branch 19 - 33 not given, set to 9900
% ***** MVA limit of branch 20 - 34 not given, set to 9900
% ***** MVA limit of branch 22 - 35 not given, set to 9900
% ***** MVA limit of branch 23 - 36 not given, set to 9900
% ***** MVA limit of branch 25 - 37 not given, set to 9900
% ***** MVA limit of branch 2 - 30 not given, set to 9900
% ***** MVA limit of branch 29 - 38 not given, set to 9900
% ***** MVA limit of branch 19 - 20 not given, set to 9900
