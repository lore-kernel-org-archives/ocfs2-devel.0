From: wengang wang <wen.gang.wang@oracle.com>
Date: Mon,  8 Jun 2009 13:14:03 +0800
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: automatic dlm hash table size
Message-ID: <200906080515.n585F9Mu012898@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

backgroud:
	ocfs2 dlm uses a hash table to store dlm_lock_resource objects. the often used lookup is performed on the hash table.

problem:
	for usages that there are huge number of inodes(thus huge number of dlm_lock_resource objects) in a ocfs2 volume, the lookup performance becomes a problem. the lookup holds spin_lock which could put all others cpus into the state of aquring the spinlock. if the lock is held long enough by the lookup process, some hardware watchdog  could reboot box since it's not fed in a time(the fed has no change to be scheduled).

	enlarging the hash table is the way to speed up the lookup. but we don't know how large is a good size. --too small, performance is bad; too large, there is a memory waste.

suggestion:
	so I suggest a automatic resizing the dlm_lock_resource hash table feature. that means it can increase the size of the hash table per the number of dlm_lock_resource objects which are already in the hash table.
	the default(smallest) size is 16 in shift bits. when the number of dlm_lock_resource rearches 250,0000, auto-resizing is triggered and the destination size is 17. and when rearches 500,0000, resize to 18, for 1000,0000, resize to 19... though the numbers need to be discussed yet.
	with this we can use proper sized memory for runtime usage and keep good enough lookup performance.

if it's good, I'm glad to do it.

thanks,
wengang.
