function [p]=prob_push_right(s)

p=(1.0 / (1.0 + exp(-max(-50.0, min(s, 50.0)))));