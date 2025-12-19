out_file_ext = '.jpg';

if ispc
	path =  '.\img_ex\';
	out_path = '.\img_out\';
elseif isunix
	path =  './img_ex/';
	out_path = './img_out/';
end

img_name = 'peppers.png';

img_file = strcat(path, img_name);

X = 5:5:25;

img = imread(img_file);

img = rgb2gray(img);
grayscale = true;

im_size = size(img);
n = size(X);

MSE_lst = zeros(n);
PSNR_lst = zeros(n);
SSIM_lst = zeros(n);
PIQE_lst = zeros(n);
NIQE_lst = zeros(n);
BRISQUE_lst = zeros(n);

if grayscale == false
	SSIM_maps = zeros(im_size(1),im_size(2),im_size(3),n(2));
else
	SSIM_maps = zeros(im_size(1),im_size(2),n(2));
end

key = ["MSE"; "PSNR"; 'Global SSIM'; 'PIQE'; 'NIQE'; 'BRISQUE'];
%%
tiledlayout(2,3)

for i = 1:5
	out_file = strcat(out_path, 'compressed', out_file_ext);
	imwrite(img, out_file, 'jpg', 'Quality',X(i));
	compressed = imread(out_file);
	if grayscale == false
		[MSE_lst(i), PSNR_lst(i), SSIM_lst(i), SSIM_maps(:,:,:,i), PIQE_lst(i), NIQE_lst(i), BRISQUE_lst(i)] = imgQuality(compressed,img);
	else
		[MSE_lst(i), PSNR_lst(i), SSIM_lst(i), SSIM_maps(:,:,i), PIQE_lst(i), NIQE_lst(i), BRISQUE_lst(i)] = imgQuality(compressed,img);
	end
	X_val = string(X(i));
	nexttile
	if grayscale == false
		imshow(SSIM_maps(:,:,:,i))
	else
		imshow(SSIM_maps(:,:,i))
	end
	title(strcat('Compressed at X= ',X_val))
end

qual_metrics = table(MSE_lst', PSNR_lst', SSIM_lst', PIQE_lst', NIQE_lst', BRISQUE_lst');
qual_metrics.Properties.VariableNames(1:6) = key;
writetable(qual_metrics,'metrics.csv')

%%


X = (1:2:9);



MSE_lst_gaus = zeros(n);
PSNR_lst_gaus = zeros(n);
SSIM_lst_gaus = zeros(n);
PIQE_lst_gaus = zeros(n);
NIQE_lst_gaus = zeros(n);
BRISQUE_lst_gaus = zeros(n);

if grayscale == false
	SSIM_maps_gaus = zeros(im_size(1),im_size(2),im_size(3),n(2));
else
	SSIM_maps_gaus = zeros(im_size(1),im_size(2),n(2));
end

MSE_lst_sp = zeros(n);
PSNR_lst_sp = zeros(n);
SSIM_lst_sp = zeros(n);
PIQE_lst_sp = zeros(n);
NIQE_lst_sp = zeros(n);
BRISQUE_lst_sp = zeros(n);

if grayscale == false
	SSIM_maps_sp = zeros(im_size(1),im_size(2),im_size(3),n(2));
else
	SSIM_maps_sp = zeros(im_size(1),im_size(2),n(2));
end

tiledlayout(5,2)

for i = 1:5

	img_gaus = imnoise(img,'gaussian',0,(0.001*X(i)));
	img_sp = imnoise(img,'salt & pepper',(0.01*X(i)));
	if grayscale == false
		[MSE_lst_gaus(i), PSNR_lst_gaus(i), SSIM_lst_gaus(i), SSIM_maps_gaus(:,:,:,i), PIQE_lst_gaus(i), NIQE_lst_gaus(i), BRISQUE_lst_gaus(i)] = imgQuality(img_gaus,img);
		[MSE_lst_sp(i), PSNR_lst_sp(i), SSIM_lst_sp(i), SSIM_maps_sp(:,:,:,i), PIQE_lst_sp(i), NIQE_lst_sp(i), BRISQUE_lst_sp(i)] = imgQuality(img_sp,img);
	else
		[MSE_lst_gaus(i), PSNR_lst_gaus(i), SSIM_lst_gaus(i), SSIM_maps_gaus(:,:,i), PIQE_lst_gaus(i), NIQE_lst_gaus(i), BRISQUE_lst_gaus(i)] = imgQuality(img_gaus,img);
		[MSE_lst_sp(i), PSNR_lst_sp(i), SSIM_lst_sp(i), SSIM_maps_sp(:,:,i), PIQE_lst_sp(i), NIQE_lst_sp(i), BRISQUE_lst_sp(i)] = imgQuality(img_sp,img);
	end
	X_val = string(X(i));
	nexttile
	if grayscale == false
		imshow(SSIM_maps_gaus(:,:,:,i))
	else
		imshow(SSIM_maps_gaus(:,:,i))
	end
	title(strcat('gaussian noise at var=0.00 ',X_val))

	nexttile
	if grayscale == false
		imshow(SSIM_maps_sp(:,:,:,i))
	else
		imshow(SSIM_maps_sp(:,:,i))
	end
	title(strcat('salt and pepper noise at var= 0.0',X_val))
end
%%


quant_imgs = figure;




R = (1:1:7);
R_len = length(R);
input_depth = 8;
I_max = (2^input_depth)-1;
figure(quant_imgs);
clf(quant_imgs);
tiledlayout(R_len,2)

if grayscale == false
	quant_imgs_linear = zeros(im_size(1),im_size(2),im_size(3),R_len);
	quant_imgs_lloyds = zeros(im_size(1),im_size(2),im_size(3),R_len);
else
	quant_imgs_linear = zeros(im_size(1),im_size(2),R_len);
	quant_imgs_lloyds = zeros(im_size(1),im_size(2),R_len);
end

for i = 1:R_len
	[part_linear, code_linear, part_lloyds, code_lloyds] = quantizer(R(i),input_depth,img);
	[quant_P_us, index_us] = imquantize(img,part_linear, code_linear);
	[quant_P_lm, index_lm] = imquantize(img,part_lloyds, code_lloyds);

	nexttile
	imshow(quant_P_us,[0 I_max])
	title(strcat('linear quantizer R=',string(R(i))))
	nexttile
	imshow(quant_P_lm, [0 I_max])
	title(strcat('lloyds quantizer R=',string(R(i))))

	if grayscale == false
		quant_imgs_linear(:,:,:,i) = quant_P_us;
		quant_imgs_lloyds(:,:,:,i) = quant_P_lm;
	else
		quant_imgs_linear(:,:,i) = quant_P_us;
		quant_imgs_lloyds(:,:,i) = quant_P_lm;
	end
end

PSNR_plot(img,quant_imgs_linear,R,grayscale,input_depth)

