From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri May  7 17:40:43 2004
Subject: [Ocfs2-devel] Code Reviewing
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B88C64D@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B88C64D@orsmsx410.jf.intel.com>
Message-ID: <20040507224038.GE1343@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

John,
	Yeah, noticed that you seemed to be doing some review of the code :)
Thanks for that. Here's a list of files NOT to bother looking over as
they're subject to change / removal during the next phase of development:
dir.c
divdi3.c
sysfile.c
namei.c

As far as what to look at: dlm.c, nm.c, vote.c and lockres.c
If you understand those files, you'll understand OCFS inter-node locking,
and (assuming your sanity is still in tact), you'll be an OCFS guru! ;)
	--Mark

On Fri, May 07, 2004 at 10:41:31AM -0700, Villalovos, John L wrote:
> So I have been doing some code reviewing of the OCFS2 code.  So far I
> have started with src/hash.c.  No major bugs found yet.  Just one where
> the forced pruning of a random bucket of the semaphore hash tree (after
> 10 times through without pruning) doesn't seem to happen
> 
> What I was wondering, is there some files that you folks at Oracle would
> think would be most beneficial to have the code reviewed?
> 
> I was going to start working on files with the smallest sizes (helps my
> stats for source files reviewed :) ).
> 
> Thanks,
> John
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
