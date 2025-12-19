%% Filtering functions

function [output, reconstructed] = downsamp_rec_filter_image(img, scale, AA_filter, rec_filter, kernel_size)

	im_size = size(img);
	output = zeros(im_size/scale);
	scaled_reconstructed = figure;
	figure(scaled_reconstructed);
	tiledlayout(1,2)

	if ~exist('kernel_size', 'var')
		kernel_size = scale;
	end

	kernel_flag = false;

	switch AA_filter
		case 'averaging'
			kernel = ones(kernel_size)./(kernel_size^2);
			kernel_flag = true;

		case 'bilinear'
			coefficients = [0.25; 0.5; 0.25];

		case 'binomial'
			coefficients = [0.0625; 0.25; 0.3705; 0.25; 0.0625];

		case 'bicubic -1'
			coefficients = [-0.0625; 0; 0.3125; 0.5; 0.3125; 0; -0.0625];

		case 'bicubic -0.0.5'
			coefficients = [-0.03125; 0; 0.28; 0.5; 0.28; 0; -0.03125];

		case 'window-sinc'
			coefficients = [-0.0153; 0; 0.2684; 0.4939; 0.2684; 0; -0.0153];

		otherwise
			kernel = 1;
			kernel_flag = true;

	end
	if kernel_flag == false
		kernel = coefficients*coefficients';
	end

	kernel_flag = false;

	offset = scale-1;

	img_prefilt = conv2(img,kernel);


	for j = 1:height(output)
		for i = 1:length(output)
			output(j,i) = img_prefilt((j*scale)-offset, (i*scale)-offset);
		end
	end

	padsize = uint32(length(output) - floor(length(img)/scale))+1;

	output(1:im_size(1)/2,1:im_size(1)/2) = output(padsize:height(output),padsize:length(output));

	nexttile
	imshow(output, [0 255])
	title(strcat('downsampled image, antialiasing method:',AA_filter))

	if exist('rec_filter','var')
		img_rec = zeros(height(output)*scale);

		for j = 1:height(output)
			for i = 1:length(output)
				img_rec((j*scale)-offset, (i*scale)-offset) = output(j,i);
			end
		end

		switch rec_filter
			case 'bilinear'
				coefficients = [0.5; 1; 0.5];

			case 'bicubic'
				coefficients = [-0.125; 0; 0.625; 1; 0.625; 0; -0.125];

			case 'nearest-neighbour'
				img_rec((j*scale)-offset:(j*scale)+offset, (i*scale)-offset:(i*scale)+offset) = output(j,i);
				kernel_flag == true;
			otherwise
		end

		if kernel_flag == false
			kernel = coefficients*coefficients';
		end


		reconstructed = conv2(img_rec,kernel);
		nexttile
		imshow(reconstructed, [0 255])
		title(strcat('reconstructed image, interpolation method:',rec_filter))
	else
		reconstructed = 0;
	end


end
