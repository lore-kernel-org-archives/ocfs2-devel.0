From: Mark Fasheh <mfasheh@suse.com>
Date: Mon,  5 Apr 2010 18:17:12 -0700
Subject: [Ocfs2-devel] [PATCH 0/4] Ocfs2 allocation tuning
Message-ID: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches apply some lessons I've learned during some testing of
a couple non-trivial workloads on Ocfs2.  Roughly speaking, they tune "up"
the default local alloc windowxs, and tune "down" the reservations code a
bit.

I primarily ran two tests - one simulating a large multi-node data-processing
workload, and the multi-threaded writers test, mtwrite at:

http://www.kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/tests/mtwrite.c

All patches were developed and tested on top of the current set of
allocation changes in ocfs2.git (primarily reservations, and the local alloc
fixes we have).  A git branch containing all the patches is available, based
off 2.6.33:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/ocfs2-mark.git disk-alloc

Basically though, this all involved many many test runs (of which I have
lots of data) and a thorough checking of fragmentation levels.  I changed
only one value at a time. Details regarding some of the test runs are within
the specific patch descriptions.
	--Mark

--
Mark Fasheh
