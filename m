From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb 17 17:19:20 2004
Subject: [Ocfs2-devel] osb->curr_trans_id
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A56902@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A56902@orsmsx403.jf.intel.com>
Message-ID: <20040217231910.GM26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 17, 2004 at 02:46:38PM -0800, Villalovos, John L wrote:
> So I was looking at the TODO list and I see these two entries:
> 
> * get rid of osb->curr_trans_id as it was never used (always zero)
> 
> * get rid of all the:
>         changeSeqNum = osb->curr_trans_id;
>         DISK_LOCK_SEQNUM(fe) = changeSeqNum;
>   code as it is equally useless.
> 
> So I was going to tackle this but I was wondering if there was anything
> I should look out for.
Yes, we've held off on this because we're not completely sure that it's
useless (more like almost sure), so you can either wait until we're sure,
or if you want to tackle it, be prepared to prove that it is indeed,
completely useless :)

> >From my quick perusing of the code it seems fairly simple but I am
> probably missing something.
> 
> So before submitting a "dumb" patch I thought I see if there was any
> comments on this.
There's actually a long trail of code and values set from values set from
values (some of which eventually hit disk) to follow, and basically none of
us has had the chance to do so :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
