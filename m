From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jun 22 04:11:13 2004
Subject: [Ocfs2-devel] The truncate_inode_page call
	inocfs_file_releasecaus es the severethroughput drop of file reading in OCFS2.
Message-ID: <3ACA40606221794F80A5670F0AF15F8404B3F1D1@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

=20

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Wim Coekaerts
>Sent: 2004=C4=EA6=D4=C222=C8=D5 16:01
>To: Zhang, Sonic
>
>the problem is, how can we notify. I think we don't want to=20
>notify every
>node on every change othewise we overload the interconnect and we don't
>have a good consistent map, if I remmeber Kurts explanation correctly.

>this has to be fixed for regular performance for sure, the question is
>how do we do this in a good way.=20

What we are thinking is like follows:
1.Both node A and node B read file foo, the cache is ok and do not =
truncate when closing.
2.When Node B open foo for writting, it get the lock in file entry of =
foo.
3.When node A open foo again for reading, it found the lock is gotten by =
node B for writting,=20
 so it should first truncate all its page caches.

It this feasible?
