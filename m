From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Sep 28 18:32:44 2005
Subject: [Ocfs2-devel] shutdown of filesystems and quorum
Message-ID: <20050928233249.GB17462@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

	I just realized.  Even with _netdev, we have a problem on Red
Hat.  Normally, we assume that netfs will start up our _netdev
filesystems and umount them on shutdown.  But what about filesystems
that aren't in /etc/fstab?  What about filesystems that are noauto?  I'm
not sure what netfs does with noauto on shutdown, but I'm certain it has
no idea about OCFS2 filesystems that aren't in /etc/fstab.  It knows
about nfs/gfs/etc, because it hardcodes those fs types.  But it only
tracks OCFS2 filesystems via the /etc/fstab entries.
	What does this mean?  Even with /etc/init.d/netfs, any
filesystem that isn't in /etc/fstab will not be umounted before the
network is stopped.  So every other node mounting that filesystem will
see:

	o network connection went away
	o heartbeat is still alive
	=> Ergo, make a quorum decision, perhaps killing myself.

Yuk.
	What should we do?  Try to persuade Red Hat to add OCFS2 as an
explicit type in netfs (means we don't even need to tell our customers
_netdev anymore)?  That doesn't help sles/debian.  We have a script for
sles.  Maybe use that everywhere?
	What are your thoughts?

Joel
-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
