From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Mar 17 17:45:35 2004
Subject: [Ocfs2-devel] Crash in ocfs_volume_thread
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B0E3DE7@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Hmm, this particular scenario I don't believe has been considered very
> much... (trying to mount a partition that failed the whole 1st mount
> business)

Well I guess you could think of it is a corrupted filesystem.
Attempting to mount a corrupted file system shouldn't cause the module
to crash with a NULL pointer error.  It should just fail in the mount.

> > So should the threads get killed if the mount fails?
> Definitely.
> 
> So then the fs is being cleaned up, but the nm thread 
> obviously isn't. Are
> any of the other threads still alive too? (Perhaps we haven't 
> even gotten a
> chance to start them yet actually).

Well it appears that at least two threads are getting created before
that part of super.c.  Then when it fails it just exits with out
cleaning up those threads.

John
