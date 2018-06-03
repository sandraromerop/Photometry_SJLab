% Example state matrix: Single state; one second pause

sma = NewStateMatrix();

sma = AddState(sma, 'Name', 'MyState', ...
    'Timer', 1,...
    'StateChangeConditions', {'Tup', 'exit'},...
    'OutputActions', {});