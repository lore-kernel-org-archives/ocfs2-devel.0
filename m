From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed May  2 13:45:12 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <17976.62685.567183.915000@samba.org>
References: <17976.62685.567183.915000@samba.org>
Message-ID: <20070502204508.GM21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 03, 2007 at 06:30:21AM +1000, tridge@samba.org wrote:
> Is anyone interested in trying clustered Samba on ocfs2?

Definitely - working well with Samba is one of the things that Ocfs2 is
interested in.


> A group of us have been working on a new design for clustered Samba
> for the last 6 months or so, and we now have something that is
> suitable for wider testing. One of the interesting aspects of the
> design is that it should work on top of just about any clustered
> filesystem, and it doesn't rely on any specific DLM or other
> infrastructure.

Does it require the file system to support cluster-aware fcntl locking?
That's the one thing that Ocfs2 doesn't do yet.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
