return function(UserEntity)
    repeat
        task.wait()
    until UserEntity:Get("ActionInProgress") == false
end