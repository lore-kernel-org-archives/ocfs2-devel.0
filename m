From: Shichangkuo <shi.changkuo@h3c.com>
Date: Sat, 16 May 2015 13:20:00 +0000
Subject: [Ocfs2-devel] =?gb2312?b?tPC4tDogIFtQQVRDSF0gb2NmczI6IHJlbW92ZSBP?=
 =?gb2312?b?Q0ZTMl9JT0NCX1NFTSBsb2NrIHR5cGUgaW4gZGlyZWN0IGlv?=
In-Reply-To: <55556992.6040002@huawei.com>
References: <55556992.6040002@huawei.com>
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF351817B139@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
    In my 10 nodes cluster, I find some strange logs in kernel.log when operating some days. logs as follws:

May 14 14:01:33 cvk68 kernel: [272684.537063] (umount,52420,10):dlm_prepare_lvb_for_migration:1216 ERROR: Mismatched lvb in lock cookie=8:982, name=M00000000000000007e012000000000, node=8
May 14 14:01:33 cvk68 kernel: [272684.537066] lockres: M00000000000000007e012000000000, owner=6, state=32
May 14 14:01:33 cvk68 kernel: [272684.537067]   last used: 0, refcnt: 11, on purge list: no
May 14 14:01:33 cvk68 kernel: [272684.537068]   on dirty list: no, on reco list: no, migrating pending: no
May 14 14:01:33 cvk68 kernel: [272684.537069]   inflight locks: 0, asts reserved: 0
May 14 14:01:33 cvk68 kernel: [272684.537069]   refmap nodes: [ 1 2 3 4 5 7 8 9 10 ], inflight=0
May 14 14:01:33 cvk68 kernel: [272684.537073]   granted queue:
May 14 14:01:33 cvk68 kernel: [272684.537074]     type=3, conv=-1, node=2, cookie=2:949, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537075] 050000000000005900000000000000001554ffffffc162ffffffec2a26ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd40000000005ffffffa00000ffffff81ffffff800001000000006d16ffffffc96400000000
May 14 14:01:33 cvk68 kernel: [272684.537092]     type=3, conv=-1, node=5, cookie=5:1103, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537094]     type=3, conv=-1, node=4, cookie=4:1117, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537095]     type=3, conv=-1, node=1, cookie=1:987, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537096]     type=3, conv=-1, node=7, cookie=7:973, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537097] 050000000000005900000000000000001554ffffffc162ffffffec2a26ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd40000000005ffffffa00000ffffff81ffffff800001000000006d16ffffffc96400000000
May 14 14:01:33 cvk68 kernel: [272684.537114]     type=3, conv=-1, node=8, cookie=8:982, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537116]     type=3, conv=-1, node=10, cookie=10:632, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537117] 050000000000005900000000000000001554ffffffc162ffffffec2a26ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd40000000005ffffffa00000ffffff81ffffff800001000000006d16ffffffc96400000000
May 14 14:01:33 cvk68 kernel: [272684.537135]     type=3, conv=-1, node=3, cookie=3:988, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537136]     type=3, conv=-1, node=9, cookie=9:399, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 14 14:01:33 cvk68 kernel: [272684.537137] 050000000000005900000000000000001554ffffffc162ffffffec2a26ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd41554ffffffc162ffffffeaffffffbbfffffff0ffffffd40000000005ffffffa00000ffffff81ffffff800001000000006d16ffffffc96400000000
May 14 14:01:33 cvk68 kernel: [272684.537154]   converting queue:
May 14 14:01:33 cvk68 kernel: [272684.537154]   blocked queue:

This seems nodes [ 2 7 9 10 ] have lvb value, but nodes [ 1 3 4 5 8 ] don't have.
So, my question is:
1, What is the function of LVB ?
2, In which case this issue occurs?
3, If the value of LVB is meaningless, could we do not compare them between different nodes?

Thanks!

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
