From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 11 Jun 2010 18:26:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove unreasonable BUG_ON()
In-Reply-To: <4BFC86F7.6030406@oracle.com>
References: <201005251058.o4PAhNOK013998@acsinet15.oracle.com>
	<4BFC0744.6050804@oracle.com>
	<20100526015417.GA2537@laptop.us.oracle.com>
	<4BFC86F7.6030406@oracle.com>
Message-ID: <20100611102650.GB3990@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-05-25 19:27, Sunil Mushran wrote:
> On 05/25/2010 06:54 PM, Wengang Wang wrote:
> >On 10-05-25 10:22, Sunil Mushran wrote:
> >>NAK
> >>
> >>How did this lockres get into the dirty list? The dlm only adds locks that
> >>it owns to that list. And such locks, by definition, can never be in the
> >>recovery list.
> >Yes that my description is not good.
> >
> >Actually, I hit the BUG_ON(res->owner != dlm->node_num); during some tests.
> >
> >When an recovery happened, the lockres' that is owned by the "dead" node is
> >marked as in recovery and the owner is set as unknown. But note that a lockres
> >owned by this node can also be marked as in recovery(and owner changed to
> >unknown). That can happen when a migration for the lockres is in progress with
> >the "dead" node. see dlm_clean_master_list().
> >
> >So it's that the owner changed from dlm->node_num to unknown when the
> >lockres is already on the list.
> 
> Ok. That needs fixing. But it's a lot more involved than this. I had
> discussed this with Srini some time back.

Any detail will follow?

regards,
wengang.
