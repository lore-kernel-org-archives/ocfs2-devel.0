From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Jul  2 17:35:26 2004
Subject: [Ocfs2-devel] On-disk changes for signedness and lock types
Message-ID: <20040702223522.GE864@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Folks,
	The bad news is, we changed the disk format again.  The good
news is, we managed to batch a few changes at once this time.
	The upshot is that r1237 of ocfs2 and r133 of ocfs-tools are
required in conjunction.  You will need to reformat your volumes.
	Also of interest, the latest ocfs-tools has debugfs.ocfs2, which
is a proper debugging interface to the filesystem.  It can dump the
details of inodes and directories, allowing examination of the on-disk
structures.
	What has changed?  Well, we had issues with node numbers being
unsigned (given that the "unset node number" was -1 -> 65536) and
comparisons between u16 and u32 variables.  That should be fixed, with
s16 variables pervailing for node numbers.  Let us know if you see
anymore problems with this.  It should't be an on-disk problem anymore,
just a kernel code problem.
	Also, the lock type values have changed.  This is a move towards
a more robust locking system.  No, that's not happening anytime soon,
but we should use common locking primitives.
	Finally, the comm_voting parameter has been removed from the
module.  Network publish/vote is always enabled now.
	Here's hoping that's the last of the changes.  Don't bet on it,
but here's hoping.  Thank you for your patience as we work these issues
out.

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
