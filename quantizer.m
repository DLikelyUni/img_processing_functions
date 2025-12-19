%% lab2
% Duncan Likely

function [part_linear, code_linear, part_lloyds, code_lloyds] = quantizer(bit_depth_out, bit_depth_in, img)

	max_in = 2^bit_depth_in;
	max_out = 2^bit_depth_out;

	levels = zeros(1,(max_out-1));
	values = zeros(1, max_out);

	value = (max_in/max_out)/2;
	values(1) = value;

	for i = 1:length(levels)
		levels(i) = max_in*(i/max_out);
		value = value + max_in/max_out;
		values(i+1) = value;
	end
	part_linear = levels;
	code_linear = values;
	[part_lloyds, code_lloyds] = lloyds(img(:),values);
end
