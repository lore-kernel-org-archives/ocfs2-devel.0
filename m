From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 12 Feb 2009 00:27:42 -0800
Subject: [Ocfs2-devel] Suggestions to fix orphan dir cleanup
Message-ID: <4993DD7E.1020907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

In 1.4 and 1.2 there is a hole that leaves orphans in a orphan directory 
till fsck was run or recovery occurs on that slot.

In the current implementation, if node A did rm of a file while it is 
opened by node B. Now if node A umounts and node B dies and is restarted 
first, it only recovers itself leaving orphan file in node A's orphan 
directory.

In order to fix the problem, I am  looking for your inputs on what is 
the best :)

1) recover all slots(osb->max_slots) whenever there is a recovery. This 
can trigger simultaneous recoveries if there were multiple node failures.

2) queue recovery  during mount(even if the journal is clean). This can 
still leave the file in orphan directory till the slot is used.

3) Initiate recovery periodically after certian interval. I do not see 
much benefit in this.

thanks,
--Srini
