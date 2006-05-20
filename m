From: Daniel Phillips <phillips@google.com>
Date: Fri, 19 May 2006 19:00:40 -0700
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <c04850370605190740s67ac3b0dpedd580ccb5f94997@mail.gmail.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>	
	<c04850370605180746l531fceb4x3ca1c7d76fef740a@mail.gmail.com>	
	<446CC185.9090306@oracle.com> <446CC939.8060502@google.com>
	<c04850370605190740s67ac3b0dpedd580ccb5f94997@mail.gmail.com>
Message-ID: <446E7848.2000004@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sum Sha wrote:
> Don't know if I am looking at very old code or not getting what you
> want to say.
> Code for OCFS2 version 1.2.0-1 says that "if a node detects that it's
> not part of quorum, then panic itself".
> 
> Inside fs/ocfs2/cluster/quorum.c: o2quo_make_decision() {
> -> A Node detects if it's part of quorum
> -> If it's not, then it calls o2quo_fence_self()
> -> o2quo_fence_self() function stops all the regions by calling
> o2hb_stop_all_regions() and then calls panic() directly with the
> message "ocfs2 is very sorry to be fencing this system by
> panicing\n"...
> }
> 
> Now tell me if in this case fencing means panic or not?
> If you want to stop a node from accessing a shared storage, then
> panicking may be a good idea (that's what you are doing here), but
> don't understand if this algorithm stops all the nodes and causes
> complete cluster shutdown, then how it can be a good idea !
> 
> Probably I am looking at the older version of the code or some more
> explaination is needed here :)

You are looking at a quick hack appropriate for a first try.  Now let's look at
what has to be done to make this more generic and less panic-oriented.

1) Self-fencing is just one possible fencing method, so we need a way of plugging
in and configuring other fencing methods.

2) There are really two parts to self-fencing:
      * Target.  Each fencing method includes a specified behavior of the
        node that is to be fenced.  We must define such behavior accurately,
        or we won't be able to use self-fencing.  For fencing methods other
        than self-fencing we still may want to define target behaviour, such
        as rebooting, or attempting self-cleanup and rejoin.  Each target
        fencing method specifies the initiation method to be used in order
        to fence this node.

      * Initiator.  Fencing must be initiated by some quorum node.  A
        particular fencing method initiates fencing by some means.  For a
        self-fencing target the initiator method simply waits some number of
        heartbeats then reports success.

OCFS2 only implements one degenerate form of self-fencing target, and no methods
of initiation.  This needs to be fixed.  I am preparing a specific proposal for
a better fencing harness for OCFS2.  Since it is too long to write in the margin
of this email, I will send it to the list next week in its own email.

Regards,

Daniel
