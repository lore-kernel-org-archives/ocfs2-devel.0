From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Wed Jul  7 03:34:46 2004
Subject: [Ocfs2-devel] flush
Message-ID: <20040707083442.GA9197@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

for those that are going to be awake now ;-)

sys_close() -> filp_close() -> ocfs_fops() -> ocfs_flush() -> fsync_buffers_list()

that happens on close. flush causes a sync to disk
so

untar of a full tree took 6:15 min
then took out the ocfs_sync_inode() from ocfs_file_release()
then lowered heartbeat to 1 per second nad commit interval now at 5
seconds

then went down to bout 4:30 minutes

then noticed the flush during untar, so I got rid of ocfs_flush() as a
test
went down to bout 2 minutes, however things are inconsistent
so it's not tha simple .but that's a huge part of the remaining
bottlenecks when comparing stuff to ext3
