{:ok, pid} = UidGeneratorPoc.start_link()
[{_, user1, _, _}, {_, user2, _, _}, {_, user3, _, _}, _] = Supervisor.which_children(pid)

for user <- [user1, user2, user3] do
  spawn(fn -> UidUser.start_using_uids(user) end)
  :timer.sleep(500)
end

UidUser.start_using_uids(user1)
UidUser.start_using_uids(user2)
UidUser.start_using_uids(user3)
