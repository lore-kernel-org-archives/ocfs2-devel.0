From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue, 02 May 2006 10:11:05 -0700
Subject: [Ocfs2-devel] Please help me in getting OCFS2 design doc.
In-Reply-To: <c04850370605020715x5b99c4c1s9f168ab0acf5840a@mail.gmail.com>
References: <c04850370605020715x5b99c4c1s9f168ab0acf5840a@mail.gmail.com>
Message-ID: <445792A9.4030508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The modules don't map one on one. The idea is to keep the
number of modules at a minimum while retaining some sense
modularity.

For e.g., ocfs2_nodemanager.ko  encompasses nm, heartbeat and net/tcp.

The various kernel/worker threads may change over time.
For e.g., we added dlm_wq in the last drop. Again, the idea is to
keep the threads at a minimum while still functioning. :)

o2cb (ocfs2 cluster stack) and crs have nothing in common. No, they
don't talk to each other. o2cb is almost entirely implemented in kernel
space while crs in userspace.

ocfs2 default timings are much shorter than crs. The idea is to recover
dead nodes before crs times out.

Sum Sha wrote:
> Thanks Sunil for this information. I tried going through the docs 
> mentioned there, they are useful, but there are details which I wanted 
> for my  learning purpose which are not in those docs. It would be 
> great if anyone can share any good doc mentioning details about 
> Clustering Services which OCFS2 uses. I know that clustering services 
> which OCFS2 uses has the following components:
>
> 1. Node manager
> 2. Heartbeat module
> 3. TCP Protocol module
> 4. DLM
>
> But once I install and configure OCFS2, I can see the following 
> modules getting loaded:
>
> 1. configfs (with filesystem mounted)
> 2. ocfs2_nodemanger
> 3. ocfs2_dlm
> 4. ocfs2_dlmfs (with filesystem mounted)
>
> and the following threads created:
> 1. ocfs2_wq (perhaps it's the kernel worker thread)
> 2. ocfs2_vote (for voting requests. Is this the listener thread?)
> 3. ocfs2_cmt (perhaps this is the node monitoring thread?)
>
> Can't think of OCFS2 in 10g environment where we have another required 
> and reliable clustering service CRS (with 10g) running and managing 
> Oracle's resources. Do CRS and OCFS's clustering services co-ordinate 
> in some manner or do they take actions independently on their own 
> during crash and other conditions?
>
> Any help would be highly appreciated!!
>
> Thanks.
> Sumsha.
>
> On 4/28/06, *ocfs2-devel-request at oss.oracle.com 
> <mailto:ocfs2-devel-request@oss.oracle.com>* < 
> ocfs2-devel-request at oss.oracle.com 
> <mailto:ocfs2-devel-request@oss.oracle.com>> wrote:
>
>     Send Ocfs2-devel mailing list submissions to
>             ocfs2-devel at oss.oracle.com <mailto:ocfs2-devel@oss.oracle.com>
>
>     To subscribe or unsubscribe via the World Wide Web, visit
>              http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>     or, via email, send a message with subject or body 'help' to
>             ocfs2-devel-request at oss.oracle.com
>     <mailto:ocfs2-devel-request@oss.oracle.com>
>
>     You can reach the person managing the list at
>             ocfs2-devel-owner at oss.oracle.com
>     <mailto:ocfs2-devel-owner@oss.oracle.com>
>
>     When replying, please edit your Subject line so it is more specific
>     than "Re: Contents of Ocfs2-devel digest..."
>
>
>     Today's Topics:
>
>        1. Re: Please help me in getting OCFS2 design doc. (Sunil Mushran)
>
>
>     ----------------------------------------------------------------------
>
>
>     Message: 1
>     Date: Thu, 27 Apr 2006 10:03:23 -0700
>     From: Sunil Mushran <Sunil.Mushran@oracle.com
>     <mailto:Sunil.Mushran@oracle.com>>
>     Subject: Re: [Ocfs2-devel] Please help me in getting OCFS2 design
>     doc.
>     To: Sum Sha <sumsha.matrixreloaded@gmail.com
>     <mailto:sumsha.matrixreloaded@gmail.com>>
>     Cc: ocfs2-devel at oss.oracle.com <mailto:ocfs2-devel@oss.oracle.com>
>     Message-ID: < 4450F95B.8000704@oracle.com
>     <mailto:4450F95B.8000704@oracle.com>>
>     Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
>     Look into docs in ocfs2 projects page. While there
>     is no design doc, there is a presentation which lists
>     out the changes.
>
>     http://oss.oracle.com/projects/ocfs2/documentation/
>
>     Sum Sha wrote:
>     > Hi all,
>     > Could someone point me to design doc for OCFS2? I could get OCFS
>     V-1
>     > design doc, but could not find any design doc for OCFS2. I read
>     > somewhere that OCFS2 has got lots of design changes as comapared to
>     > OCFS1.
>     >
>     > Thanks in advance.
>     >
>     > _______________________________________________
>     > Ocfs2-devel mailing list
>     > Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>     <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>
>     >
>
>
>
>     ------------------------------
>
>     _______________________________________________
>     Ocfs2-devel mailing list
>     Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
>     End of Ocfs2-devel Digest, Vol 25, Issue 10
>     *******************************************
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
