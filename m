From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri May  7 12:41:38 2004
Subject: [Ocfs2-devel] Code Reviewing
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B88C64D@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I have been doing some code reviewing of the OCFS2 code.  So far I
have started with src/hash.c.  No major bugs found yet.  Just one where
the forced pruning of a random bucket of the semaphore hash tree (after
10 times through without pruning) doesn't seem to happen

What I was wondering, is there some files that you folks at Oracle would
think would be most beneficial to have the code reviewed?

I was going to start working on files with the smallest sizes (helps my
stats for source files reviewed :) ).

Thanks,
John
