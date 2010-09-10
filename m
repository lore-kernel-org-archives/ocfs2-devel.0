From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 10 Sep 2010 12:08:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: retry migrating if nomem or
 lockres is in recovery on target
In-Reply-To: <4C898CDA.10708@oracle.com>
References: <201008311544.o7VESwg1014110@acsinet15.oracle.com>
	<4C898CDA.10708@oracle.com>
Message-ID: <20100910040840.GB2420@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OK.
This is not a customer reported problem. It's found when I was testing
other patches. And it can be easily reproduced(around 50%).

I will think more on the reco+mig race.

regards,
wengang.
On 10-09-09 18:41, Sunil Mushran wrote:
> I don't think this fixes the issue. As in, the fix for reco+mig race is a
> lot more involved. Is someone hitting this freq? As in, this should be
> a hard race to reproduce.
> 
> On 08/31/2010 08:41 AM, Wengang Wang wrote:
> >This patch tries to fix two problems:
> >
> >problem 1):
> >It's a case of recovery + migration. That is a recovery is happening when node I
> >is in progress of umount. Node I is the recovery master.
> >Say lockres A was mastered by the dead node and need to be recovered. Node I(the
> >reco master) and node II both have reference on lockres A.
> >So lockres A is being recovered from node II to node I, with RECOVERING flag set.
> >The umounting process is going on, it happened to be migrating lockres A to node
> >II. Since recovery not finished yet(RECOVERING still set), node II reponds with
> >-EFAULT to kill node I. Then node I killed its self(BUGON).
> >
> >There is a checking for recovery(on RECOVERING), but it droped res->spinlock and
> >dlm->spinlock. So the checking does not help much enough.
> >
> >Since we have to drop any spinlock when we are sending migrate lockres(
> >DLM_MIG_LOCKRES_MSG) message, we have to deal with above case.
> >
> >problem 2):
> >In the same context of problem 1), -ENOMEM from target node can trigger an
> >incorrect BUG() on the requester of "migrate lockres".
> >
> >The fix is when target node returns -EFAULT or -ENOMEM, we retry the migration(
> >for umount).
> >Though they are two separated problems, the fixes are in the same way. So I
> >combined them together.
> >
