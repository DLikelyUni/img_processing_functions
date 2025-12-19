%% Image Quality Metrics
% Duncan Likely

function [MSE, PSNR, ssimval, ssimmap, PIQE, NIQE, BRISQUE] = imgQuality(A, ref, peakval)

	A = double(A);
	ref = double(ref);
	% Full Reference Metrics
	if exist('ref', 'var')
		% calculate MSE
		MSE = immse(A,ref);

		if exist('peakval', 'var')
			% calculate PSNR at specified peakval
			PSNR = psnr(A,ref,peakval);
		else
			% otherwise calc PSNR with regular inputs
			PSNR = psnr(A,ref);
		end
		% SSIM calculations
		[ssimval, ssimmap] = ssim(A,ref);
	end

	% Non Reference Image Metrics
	PIQE = piqe(A);
	NIQE = niqe(A);
	BRISQUE = brisque(A);


end
