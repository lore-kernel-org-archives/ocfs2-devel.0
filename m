From: Roberto Giordani <r.giordani@libero.it>
Date: Fri, 20 Aug 2010 12:50:31 +0200
Subject: [Ocfs2-devel] ocfs2 hang writing until reboot the cluster-dlm:
 set_fs_notified: set_fs_notified no nodeid 1812048064#012
Message-ID: <4C6E5DF7.8000002@libero.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,
I hope this mailing list is correct.
I've a cluster pacemaker with a clone resource ocfs2 with
ocfs2-tools-1.4.1-25.6.x86_64
ocfs2-tools-o2cb-1.4.1-25.6.x86_64
on Opensuse 11.2

After some network problem on my switch I receive on one of 4 nodes of
my cluster the following messages

Aug 18 13:12:28 nodo1 openais[8462]: [TOTEM] The token was lost in the
OPERATIONAL state.
Aug 18 13:12:28 nodo1 openais[8462]: [TOTEM] Receive multicast socket
recv buffer size (262142 bytes).
Aug 18 13:12:28 nodo1 openais[8462]: [TOTEM] Transmit multicast socket
send buffer size (262142 bytes).
Aug 18 13:12:28 nodo1 openais[8462]: [TOTEM] entering GATHER state from 2.
Aug 18 13:12:31 nodo1 cluster-dlm: update_cluster: Processing membership
235508#012
Aug 18 13:12:31 nodo1 cluster-dlm: dlm_process_node: Skipped active node
1778493632 'nodo1': born-on=235504, last-seen=235508, this-event=235508,
last-event=235504#012
Aug 18 13:12:31 nodo1 cluster-dlm: dlm_process_node: Skipped inactive
node 1812048064 'nodo3': born-on=235504, last-seen=235504,
this-event=235508, last-event=235504#012
Aug 18 13:12:31 nodo1 cluster-dlm: add_change: add_change cg 3 remove
nodeid 1812048064 reason 3#012
Aug 18 13:12:31 nodo1 cluster-dlm: add_change: add_change cg 3 counts
member 1 joined 0 remove 1 failed 1#012
Aug 18 13:12:31 nodo1 cluster-dlm: stop_kernel: stop_kernel cg 3#012
Aug 18 13:12:31 nodo1 cluster-dlm: do_sysfs: write "0" to
"/sys/kernel/dlm/0BB443F896254AD3BA8FB960C425B666/control"#012
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] entering GATHER state from 0.
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] Creating commit token
because I am the rep.
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] Saving state aru e1 high
seq received e1
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] Storing new sequence id for
ring 397f4
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] entering COMMIT state.
Aug 18 13:12:31 nodo1 cib: [8475]: notice: ais_dispatch: Membership
235508: quorum lost
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] entering RECOVERY state.
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] position [0] member
192.168.1.106:
Aug 18 13:12:31 nodo1 crmd: [8479]: notice: ais_dispatch: Membership
235508: quorum lost
Aug 18 13:12:31 nodo1 cluster-dlm: purge_plocks: purged 0 plocks for
1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: [8721]: notice: ais_dispatch:
Membership 235508: quorum lost
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] previous ring seq 235504
rep 192.168.1.106
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] aru e1 high delivered e1
received flag 1
Aug 18 13:12:31 nodo1 ocfs2_controld: [8786]: notice: ais_dispatch:
Membership 235508: quorum lost
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] Did not need to originate
any messages in recovery.
Aug 18 13:12:31 nodo1 cib: [8475]: info: crm_update_peer: Node nodo3:
id=1812048064 state=lost (new) addr=r(0) ip(192.168.1.108)  votes=1
born=235504 seen=235504 proc=00000000000000000000000000053312
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] Sending initial ORF token
Aug 18 13:12:31 nodo1 crmd: [8479]: info: ais_status_callback: status:
nodo3 is now lost (was member)
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] CLM CONFIGURATION CHANGE
Aug 18 13:12:31 nodo1 cluster-dlm: [8721]: info: crm_update_peer: Node
nodo3: id=1812048064 state=lost (new) addr=r(0) ip(192.168.1.108) 
votes=1 born=235504 seen=235504 proc=00000000000000000000000000053312
Aug 18 13:12:31 nodo1 ocfs2_controld: [8786]: info: crm_update_peer:
Node nodo3: id=1812048064 state=lost (new) addr=r(0) ip(192.168.1.108) 
votes=1 born=235504 seen=235504 proc=00000000000000000000000000053312
Aug 18 13:12:31 nodo1 cib: [8475]: info: ais_dispatch: Membership
235508: quorum still lost
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] New Configuration:
Aug 18 13:12:31 nodo1 crmd: [8479]: info: crm_update_peer: Node nodo3:
id=1812048064 state=lost (new) addr=r(0) ip(192.168.1.108)  votes=1
born=235504 seen=235504 proc=00000000000000000000000000053312
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] #011r(0) ip(192.168.1.106) 
Aug 18 13:12:31 nodo1 cluster-dlm: [8721]: info: ais_dispatch:
Membership 235508: quorum still lost
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] Members Left:
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] #011r(0) ip(192.168.1.108) 
Aug 18 13:12:31 nodo1 crmd: [8479]: info: erase_node_from_join: Removed
node nodo3 from join calculations: welcomed=0 itegrated=0 finalized=0
confirmed=1
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] Members Joined:
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] notice: pcmk_peer_update:
Transitional membership event on ring 235508: memb=1, new=0, lost=1
Aug 18 13:12:31 nodo1 crmd: [8479]: info: crm_update_quorum: Updating
quorum status to false (call=281)
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info: pcmk_peer_update:
memb: nodo1 1778493632
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info: pcmk_peer_update:
lost: nodo3 1812048064
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] CLM CONFIGURATION CHANGE
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] New Configuration:
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] #011r(0) ip(192.168.1.106) 
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] Members Left:
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] Members Joined:
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] notice: pcmk_peer_update:
Stable membership event on ring 235508: memb=1, new=0, lost=0
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info: pcmk_peer_update:
MEMB: nodo1 1778493632
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info:
ais_mark_unseen_peer_dead: Node nodo3 was not seen in the previous
transition
Aug 18 13:12:31 nodo1 openais[8462]: [MAIN ] info: update_member: Node
1812048064/nodo3 is now: lost
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info:
send_member_notification: Sending membership update 235508 to 4 children
Aug 18 13:12:31 nodo1 openais[8462]: [MAIN ] info: update_member:
0x7f12080009a0 Node 1778493632 ((null)) born on: 235504
Aug 18 13:12:31 nodo1 openais[8462]: [SYNC ] This node is within the
primary component and will provide service.
Aug 18 13:12:31 nodo1 openais[8462]: [TOTEM] entering OPERATIONAL state.
Aug 18 13:12:31 nodo1 openais[8462]: [MAIN ] info: update_member:
0x7f12080009a0 Node 1778493632 (nodo1) born on: 235504
Aug 18 13:12:31 nodo1 openais[8462]: [crm  ] info:
send_member_notification: Sending membership update 235508 to 4 children
Aug 18 13:12:31 nodo1 openais[8462]: [CLM  ] got nodejoin message
192.168.1.106
Aug 18 13:12:31 nodo1 openais[8462]: [CPG  ] got joinlist message from
node 1778493632
Aug 18 13:12:31 nodo1 ocfs2_controld: [8786]: info: ais_dispatch:
Membership 235508: quorum still lost
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_request: Operation
complete: op cib_modify for section nodes (origin=local/crmd/279): ok
(rc=0)
Aug 18 13:12:31 nodo1 haclient: on_event:evt:cib_changed
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_config_changed: Attr changes
Aug 18 13:12:31 nodo1 haclient: on_event:evt:cib_changed
Aug 18 13:12:31 nodo1 cib: [8475]: info: log_data_element: cib:diff: -
<cib have-quorum="1" admin_epoch="0" epoch="1655" num_updates="37" />
Aug 18 13:12:31 nodo1 cib: [8475]: info: log_data_element: cib:diff: +
<cib have-quorum="0" admin_epoch="0" epoch="1656" num_updates="1" />
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_request: Operation
complete: op cib_modify for section cib (origin=local/crmd/281): ok (rc=0)
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_xpath: Processing
cib_query op for
//cib/configuration/crm_config//nvpair[@name='expected-quorum-votes']
(/cib/configuration/crm_config/cluster_property_set/nvpair[2])
Aug 18 13:12:31 nodo1 crmd: [8479]: info: abort_transition_graph:
need_abort:59 - Triggered transition abort (complete=1) : Non-status change
Aug 18 13:12:31 nodo1 crmd: [8479]: info: need_abort: Aborting on change
to have-quorum
Aug 18 13:12:31 nodo1 crmd: [8479]: info: ais_dispatch: Membership
235508: quorum still lost
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_request: Operation
complete: op cib_modify for section crm_config (origin=local/crmd/283):
ok (rc=0)
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_request: Operation
complete: op cib_modify for section nodes (origin=local/crmd/284): ok
(rc=0)
Aug 18 13:12:31 nodo1 cluster-dlm: fence_node_time: Node
1812048064/nodo3 was last shot 'now'#012
Aug 18 13:12:31 nodo1 cluster-dlm: fence_node_time: It does not appear
node 1812048064/nodo3 has been shot#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fencing_done: check_fencing
1812048064 1282129898 fenced at 1282129951#012
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_xpath: Processing
cib_query op for
//cib/configuration/crm_config//nvpair[@name='expected-quorum-votes']
(/cib/configuration/crm_config/cluster_property_set/nvpair[2])
Aug 18 13:12:31 nodo1 crmd: [8479]: info: do_state_transition: State
transition S_IDLE -> S_POLICY_ENGINE [ input=I_PE_CALC
cause=C_FSA_INTERNAL origin=abort_transition_graph ]
Aug 18 13:12:31 nodo1 crmd: [8479]: info: do_state_transition: All 1
cluster nodes are eligible to run resources.
Aug 18 13:12:31 nodo1 crmd: [8479]: info: do_pe_invoke: Query 288:
Requesting the current CIB: S_POLICY_ENGINE
Aug 18 13:12:31 nodo1 cib: [8475]: info: cib_process_request: Operation
complete: op cib_modify for section crm_config (origin=local/crmd/287):
ok (rc=0)
Aug 18 13:12:31 nodo1 cluster-dlm: check_fencing_done: check_fencing
done#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_quorum_done: check_quorum
disabled#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fs_done: check_fs nodeid
1812048064 needs fs notify#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fencing_done: check_fencing
done#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_quorum_done: check_quorum
disabled#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fs_done: check_fs nodeid
1812048064 needs fs notify#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fencing_done: check_fencing
done#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_quorum_done: check_quorum
disabled#012
Aug 18 13:12:31 nodo1 cluster-dlm: check_fs_done: check_fs done#012
Aug 18 13:12:31 nodo1 cluster-dlm: send_info: send_start cg 3 flags 2
counts 2 1 0 1 1#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: receive_start: receive_start
1778493632:3 len 76#012
Aug 18 13:12:31 nodo1 cluster-dlm: match_change: match_change
1778493632:3 matches cg 3#012
Aug 18 13:12:31 nodo1 cluster-dlm: wait_messages_done: wait_messages cg
3 got all 1#012
Aug 18 13:12:31 nodo1 cluster-dlm: start_kernel: start_kernel cg 3
member_count 1#012
Aug 18 13:12:31 nodo1 cluster-dlm: update_dir_members: dir_member
1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: update_dir_members: dir_member
1778493632#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_configfs_members: set_members
rmdir
"/sys/kernel/config/dlm/cluster/spaces/0BB443F896254AD3BA8FB960C425B666/nodes/1812048064"#012

Aug 18 13:12:31 nodo1 cluster-dlm: do_sysfs: write "1" to
"/sys/kernel/dlm/0BB443F896254AD3BA8FB960C425B666/control"#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
Aug 18 13:12:31 nodo1 cluster-dlm: set_fs_notified: set_fs_notified no
nodeid 1812048064#012
...............................
and so on with the same messages until other node fence it.

I've searched on internet some info but nobody has the same problem.
I've tried to post the same error to clusterlabs mailing list without
answer.

I've notice that if I remove the FC cable from the node in error the log
messages stops, so I suppose is some problem due lock manager+ocfs2 and
network problem.

Could someone help me?

Regards,
Roberto.
