clc;
warning off;

%����ץȡ
[sourcefile, status] = urlread('http://ris.szpl.gov.cn/credit/showcjgs/ysfcjgs.aspx?cjType=0'); %������ַ

if ~status
error('��ȡ����\n')
end

%������ȡ������ͨ�����������ȡ������Ϣ��
expr1 = '\S*\d\d\d\d��\d\d��\d\d��\S*'; %��ȡ����           
datefile= regexp(sourcefile, expr1, 'match');
datefile=datefile{1,1};
date = datefile(end-10:end);
year=str2num(datefile(end-10:end-7));
month=str2num(datefile(end-5:end-4));
day=str2num(datefile(end-2:end-1));

 expr2 = '<td width="14%"><b>С��</b></td><td width="14%"><b>\d*</b>'; %��ȡ�ɽ�����
chengjiaoxiaoji = regexp(sourcefile, expr2, 'match');
chengjiaoxiaoji=chengjiaoxiaoji{1,1};
chengjiaoxiaoji=regexp(chengjiaoxiaoji,'>(\d*)</b>','tokens');


expr3='align="right"><b>\d*';
junjia = regexp(sourcefile, expr3, 'match');%��ȡ�ɽ�����
junjia=junjia{1,2};
junjia=regexp(junjia,'<b>(\d*)','tokens');


expr4='<td width="14%">\d*';%��ȡ��������
keshou=regexp(sourcefile, expr4, 'match');
keshou=keshou{1,45};
keshou=regexp(keshou,'">(\d*)','tokens');

%�������ݵ�Excel
filename = sprintf('%d��������Ʒ����Ϣ.xls',year);
pathname = [pwd '\data'];

if ~exist(pathname,'dir')  
mkdir(pathname);
end

filepath = [pwd '\data\' filename];
sheet = sprintf('%d��������Ʒ����Ϣ', year);

if ~exist(filepath,'file')%�ж�·�����Ƿ�����ļ�����������ڴ������ļ�
    head={'����','�ɽ�����','�ɽ�����(Ԫ)','��������'};
    xlswrite(filepath,head,sheet);
end

[a,b,i]=xlsread(filepath,sheet);%filepathΪx.xls�ļ�·��
range = sprintf('A%d',size(i,1)+1);%�ж�·�����Ѵ����ļ�������������һ��׷�������ݡ�
shuju= {date,cell2mat(chengjiaoxiaoji{1,1}),cell2mat(junjia{1,1}),cell2mat(keshou{1,1})};%��cell��ʽ������ȡ������ת��Ϊmat��ʽ��������cellд��excel�ļ���
xlswrite(filepath, shuju,sheet,range);
helpdlg('���ݻ�ȡ�ɹ�!')
edittext=sprintf('������Ϣ��%d��%d��%d��,����%d',year,month,day,str2double(junjia{1,1}));