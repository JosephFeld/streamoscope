point_num = 8192;
fs_MHz = 100;
rx_t_us = 0:(1/fs_MHz):(point_num-1)*(1/fs_MHz);
Adc_data = sin(10*rx_t_us)*(2^13-1);

fp=fopen('Adc_data.txt','w');%'A.txt'Ϊ�ļ�����'a'Ϊ�򿪷�ʽ���ڴ򿪵��ļ�ĩ��������ݣ����ļ��������򴴽���
for ii = 1:length(Adc_data)
    fprintf(fp,'%04x\n',typecast(int16(Adc_data(ii)),'uint16'));%fpΪ�ļ������ָ��Ҫд�����ݵ��ļ���ע�⣺%d���пո�
end
fclose(fp);%�ر��ļ���