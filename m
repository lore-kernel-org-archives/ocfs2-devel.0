From: tridge@samba.org <tridge@samba.org>
Date: Wed May  2 13:29:36 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
Message-ID: <17976.62685.567183.915000@samba.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Is anyone interested in trying clustered Samba on ocfs2?

A group of us have been working on a new design for clustered Samba
for the last 6 months or so, and we now have something that is
suitable for wider testing. One of the interesting aspects of the
design is that it should work on top of just about any clustered
filesystem, and it doesn't rely on any specific DLM or other
infrastructure.

So I'd be very interested to hear if anyone tries it with ocfs2. So
far its only been tested with GPFS (and it performed very well).

See http://wiki.samba.org/index.php/CTDB_Setup for setup details.

Cheers, Tridge
