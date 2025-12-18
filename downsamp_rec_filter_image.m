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
    
    
    switch AA_filter
        case 'averaging'
            kernel = ones(kernel_size)./(kernel_size^2);

        case 'bilinear'


        case 'binomial'

        case 'bicubic'

        case 'window_sinc'

        otherwise
            kernel = 1;

    end

    offset = scale-1;

    img_prefilt = conv2(img,kernel);
    

    for j = 1:height(output)
        for i = 1:length(output)
            output(j,i) = img_prefilt((j*scale)-offset, (i*scale)-offset);
        end
    end
    
    nexttile
    imshow(output, [0 255])
    title(strcat('downsampled image, antialiasing method:',AA_filter))

    if exist('rec_filter','var')
        img_rec = zeros(height(output)*scale);
        
        for j = 1:height(output)
            for i = 1:length(output)
                if rec_filter == 'nearest neighbour'
                    img_rec((j*scale)-offset:(j*scale)+offset, (i*scale)-offset:(i*scale)+offset) = output(j,i);
                else
                    img_rec((j*scale)-offset, (i*scale)-offset) = output(j,i);
                end
            end
        end

        switch rec_filter
            case 'bilinear'

            case 'bicubic'

            otherwise
        end
        reconstructed = img_rec;
        nexttile
        imshow(reconstructed, [0 255])
        title(strcat('reconstructed image, interpolation method:',rec_filter))
    else
        reconstructed = 0;
    end

    
end