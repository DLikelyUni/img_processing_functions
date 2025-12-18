%% PSNR Display
% Duncan Likely

function PSNR_plot(ref, imgs, R, grayscale, bit_depth)

    PSNRplot = figure;
    SSIM_map = figure;
    clf(SSIM_map)
    clf(PSNRplot)

    
    n = length(R);
    im_size = size(ref);
    
    if ~exist('bit_depth','var')
        bit_depth = 8;
    end

    I_max = 2^bit_depth;
    range = [0 I_max];

    MSE_lst = zeros(n);
    PSNR_lst = zeros(n);
    SSIM_lst = zeros(n);
    PIQE_lst = zeros(n);
    NIQE_lst = zeros(n);
    BRISQUE_lst = zeros(n);

    if ~exist('grayscale','var')
        grayscale = true;
    end
    
    if grayscale == false
        SSIM_maps = zeros(im_size(1),im_size(2),im_size(3),n);
    else
        SSIM_maps = zeros(im_size(1),im_size(2),n);
    end

    figure(SSIM_map)
    tiledlayout(2,ceil(n/2))

    for i = 1:n
        
        if grayscale == false
            [MSE_lst(i), PSNR_lst(i), SSIM_lst(i), SSIM_maps(:,:,:,i), PIQE_lst(i), NIQE_lst(i), BRISQUE_lst(i)] = imgQuality(imgs(:,:,:,i),ref,255);
        else
            [MSE_lst(i), PSNR_lst(i), SSIM_lst(i), SSIM_maps(:,:,i), PIQE_lst(i), NIQE_lst(i), BRISQUE_lst(i)] = imgQuality(imgs(:,:,i),ref,255);
        end
        R_val = string(R(i));
        SSIM_val = string(SSIM_lst(i));
        nexttile
        if grayscale == false
            imshow(SSIM_maps(:,:,:,i))
        else
            imshow(SSIM_maps(:,:,i))
        end
            title(strcat('Local SSIM map at R= ',R_val,' SSIM =', SSIM_val))
    end

    figure(PSNRplot)
    semilogy(R,PSNR_lst)
    title('Rate Distortion Graph')
    ylabel('PSNR(dB)')
    xlabel('Rate(bpp)')

end