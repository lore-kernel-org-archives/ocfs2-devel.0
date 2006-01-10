From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Jan 2006 00:34:01 -0800
Subject: [Ocfs2-devel] Mutexes
Message-ID: <20060110083401.GU18439@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Everyone,
	The new mutexes just landed in mainline (commit
80c0531514516e43ae118ddf38424e06e5c3cb3c).  They replace single-holder
semaphores (only one locker at a time).  Now that ocfs2 is in mainline,
the conversions of i_sem to i_mutex was done for us.  However, ocfs2 has
some other semaphores that were not converted, as the mutex people
probably weren't aware of them.
	There are two restrictions on mutexes that did not exist on
semaphores-used-as-mutexes.  First, a mutex cannot be unlocked in a
different context.  So, if a user process locks a semaphore, and then
the vote thread unlocks it, you cannot convert that semaphore to a
mutex.  Second, you cannot use mutexes as completions (pretty much for
the reason above, but I wanted to describe the use case).  So either you
convert that semaphore to a struct completion, or you leave it a
semaphore.
	We need to go over the other semaphores in ocfs2 -- ip_io_sem,
recovery_lock, and o2nm_cluster_group.cs_subsys.su_sem -- to see if they
are candidates for mutex conversion.  The su_sem from configfs looks
like a candidate right off the bat.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
