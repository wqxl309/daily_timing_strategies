clear;
clc;

indices={'000001','000300','000905','000016','399001'};
types={'annret','sharp','calmar'};

tscost=2/1000;
type=1;

lowers=[2,20,60];
uppers=[20,60,120];
stepsize=[2,5,5];
windowlen=uppers(3);
testparas=TestParasGen(lowers,uppers,stepsize);
paraskip=~( (testparas(:,1)<testparas(:,2)) & (testparas(:,2)<testparas(:,3)) );

starts=[19960101,20050408,20070115,20040102,19960101]; %数据截取开始日
skips =[20000101,20060101,20080101,20050101,20000101]; %开始发信号日期
trains=[20010101,20070101,20090101,20060101,20010101]; %外推开始计算日
ends  =[20160630,20160630,20160630,20160630,20160630]; %截取数据结束日

func=@MA_V3;

%%
[errors]=calc_alldata(indices,lowers,uppers,stepsize,skips,type,tscost,starts,ends,paraskip,func);
errors

%%
errors_insp=calc_inspdata(indices,lowers,uppers,stepsize,trains,type,tscost,starts,ends,paraskip,func);
errors_insp

%%
[errors_best]=bestparas_all_final(indices,types,lowers,uppers,stepsize,trains,paraskip);
errors_best


%%
[errors_out]=outsample_validation(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_out

%%
[errors_in]=insample_validation(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_in

%%
[errors_out_cont]=outsample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_out_cont

%%
[errors_in_cont]=insample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_in_cont


%%
load('validation_result_in');
load('validation_result_out');
load('validation_result_in_continue');
load('validation_result_out_continue');
[valresults,idxresults]=Output_Insample_Best(indices,types,paraskip);
temp=[valresults;Output_Validation_Result(validation_result_in);Output_Validation_Result(validation_result_out);...
      Output_Validation_Result(validation_result_in_continue);Output_Validation_Result(validation_result_out_continue)]

