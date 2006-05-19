From: Sum Sha <sumsha.matrixreloaded@gmail.com>
Date: Fri, 19 May 2006 20:10:42 +0530
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <446CC939.8060502@google.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
	<c04850370605180746l531fceb4x3ca1c7d76fef740a@mail.gmail.com>
	<446CC185.9090306@oracle.com> <446CC939.8060502@google.com>
Message-ID: <c04850370605190740s67ac3b0dpedd580ccb5f94997@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Don't know if I am looking at very old code or not getting what you
want to say.
Code for OCFS2 version 1.2.0-1 says that "if a node detects that it's
not part of quorum, then panic itself".

Inside fs/ocfs2/cluster/quorum.c: o2quo_make_decision() {
-> A Node detects if it's part of quorum
-> If it's not, then it calls o2quo_fence_self()
-> o2quo_fence_self() function stops all the regions by calling
o2hb_stop_all_regions() and then calls panic() directly with the
message "ocfs2 is very sorry to be fencing this system by
panicing\n"...
}

Now tell me if in this case fencing means panic or not?
If you want to stop a node from accessing a shared storage, then
panicking may be a good idea (that's what you are doing here), but
don't understand if this algorithm stops all the nodes and causes
complete cluster shutdown, then how it can be a good idea !

Probably I am looking at the older version of the code or some more
explaination is needed here :)

Thanks.
Sumsha.

On 5/19/06, Daniel Phillips <phillips@google.com> wrote:
> Zach Brown wrote:
> > Sum Sha wrote:
> >
> >>With some experiments and going through OCFS2's quorum code, I am sure
> >>that in case of serial split-brain, quorum algorithm will surely break
> >>and will cause complete cluster shutdown. It will cause all the
> >>subcluster nodes to panic themselves. Please correct me if I am
> >>wrong...
> >
> > Can you provide the details that lead you to be sure of your analysis?
>
> It seems to be the intended behavior.  No node is a member of a quorum
> group so all nodes should be fenced.  This is correct.
>
> What is wrong is the idea that fencing is equivalent to panicking.  No!
> Fencing means preventing a particular node from writing to shared storage.
> The FAQ item is incorrect.  How about this instead?
>
> Q03     What is fencing?
> A03     Fencing is the act of preventing a node from writing to shared
>          cluster storage.
>
> Regards,
>
> Daniel
>
