From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Jul  7 04:55:14 2004
Subject: [Ocfs2-devel] flush
Message-ID: <3ACA40606221794F80A5670F0AF15F8404D1C353@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So there are two call to ocfs_sync_inode when closing file.
How about also removing the ocfs_sync_inode in ocfs_file_open ?

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Wim Coekaerts
>Sent: 2004=C4=EA7=D4=C27=C8=D5 16:35
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] flush
>
>for those that are going to be awake now ;-)
>
>sys_close() -> filp_close() -> ocfs_fops() -> ocfs_flush() ->
>fsync_buffers_list()
>
>that happens on close. flush causes a sync to disk
>so
>
>untar of a full tree took 6:15 min
>then took out the ocfs_sync_inode() from ocfs_file_release()
>then lowered heartbeat to 1 per second nad commit interval now at 5
>seconds
>
>then went down to bout 4:30 minutes
>
>then noticed the flush during untar, so I got rid of ocfs_flush() as a
>test
>went down to bout 2 minutes, however things are inconsistent
>so it's not tha simple .but that's a huge part of the remaining
>bottlenecks when comparing stuff to ext3
>
>
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>=20
