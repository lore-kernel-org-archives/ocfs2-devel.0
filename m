From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 15 Dec 2009 14:48:39 -0800
Subject: [Ocfs2-devel] [RFC 0/4] Ocfs2 allocation reservations
Message-ID: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, the following patches implement allocation reservations for Ocfs2. Right
now I'd consider them to be beta quality - simple operations work but the
code likely won't survive a kernel build. As it is implemented, the code
only takes reservations on the local alloc bitmap. I've divorced the
structures from any bitmap type however, so we can extend this to the chain
allocators with only a small amount of code. Also, there's nothing in
reservations.c which depends on a struct inode.

Also worth mentioning is that the mount option ("resv_level=") was kind of
hastily put together. I think we definitely want the option to control how
aggressive the code is with reservations, but I'm not sure I'm happy with the
implementation of that knob.


I still need to do some tuning, but already an increase in contiguousness
can be shown in this small test:

/root/extendo /ocfs2/try1 4 1000 32 & \
/root/extendo /ocfs2/try2 4 1000 32 & \
/root/extendo /ocfs2/try3 4 1000 32 &

So that runs 3 instances of 'extendo' (from ocfs2-test) which should write
about 4k 32 times, with a 1 second wait in between runs. Test file system was
formatted with 4k clusters and inline-data turned off.

Without reservations turned on, we get perfect fragmentation.

Inode: 66007    % fragmented: 100.00    clusters: 32    extents: 32
Inode: 66009    % fragmented: 100.00    clusters: 32    extents: 32
Inode: 66008    % fragmented: 100.00    clusters: 32    extents: 32

This version of the reservations code shows the following improvements:

Inode: 66007    % fragmented: 50.00     clusters: 32    extents: 16
Inode: 66009    % fragmented: 68.75     clusters: 32    extents: 22
Inode: 66008    % fragmented: 43.75     clusters: 32    extents: 14

All comments are appreciated.
	--Mark

--
Mark Fasheh
