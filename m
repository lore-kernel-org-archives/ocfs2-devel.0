From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 21 Aug 2011 21:45:57 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: fix slow deleting
In-Reply-To: <201107291006.p6TA6S24005662@acsmt356.oracle.com>
References: <201107291006.p6TA6S24005662@acsmt356.oracle.com>
Message-ID: <20110822044556.GH31134@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 29, 2011 at 06:06:14PM +0800, Wengang Wang wrote:
> There is a case that the application deletes a large number(XX kilo) of files in
> short time (5 minutes). The deletions of some specific files are extreamly slow
> (costing xx~xxx seconds). That is unacceptable.
> 
> Reading out the dir entries and the relavent inodes cost time. And we are doing
> that with i_mutex held, it causes unlink path waiting on the mutex for long time.
> 
> fix:
> make the orphanscan work with lower priority. That means when unlink/delete_inode,
> come, orphanscan should break the walking in orphandir and release the lock(mutex and
> cluster lock). 

	I see what you're getting at here, but I'm not sure I like the
flag method.  Gotta think about it.

Joel

-- 

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

			http://www.jlbec.org/
			jlbec at evilplan.org
