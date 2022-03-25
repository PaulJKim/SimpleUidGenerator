{:ok, pid} = UidGeneratorPoc.start_link()
IO.inspect(Supervisor.which_children(pid))
[{_, user1, _, _}, {_, user2, _, _}, {_, user3, _, _}, _] = Supervisor.which_children(pid)

UidUser.start_using_uids(user1)
UidUser.start_using_uids(user2)
UidUser.start_using_uids(user3)
