From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 29 Jul 2016 10:47:13 -0700
Subject: [Ocfs2-devel] [patch 4/5] ocfs2/dlm: solve a BUG when deref
 failed in dlm_drop_lockres_ref
In-Reply-To: <579AC8C2.5070402@huawei.com>
References: <579a73bd.aWzQ0Rkjfu9OwqME%akpm@linux-foundation.org>
	<20160728221204.GD5316@wotan.suse.de> <579AC8C2.5070402@huawei.com>
Message-ID: <20160729174713.GG5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 29, 2016 at 11:08:50AM +0800, piaojun wrote:
> Hello Mark,
> 
> On 2016-7-29 6:12, Mark Fasheh wrote:
> > On Thu, Jul 28, 2016 at 02:06:05PM -0700, Andrew Morton wrote:
> >> From: piaojun <piaojun@huawei.com>
> >> Subject: ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref
> >>
> >> We found a BUG situation that lockres is migrated during deref described
> >> below.  To solve the BUG, we could purge lockres directly when other node
> >> says I did not have a ref.  Additionally, we'd better purge lockres if
> >> master goes down, as no one will response deref done.
> >>
> >> Node 1                  Node 2(old master)             Node3(new master)
> >> dlm_purge_lockres
> >> send deref to N2
> >>
> >>                         leave domain
> >>                         migrate lockres to N3
> >>                                                        finish migration
> >>                                                        send do assert
> >>                                                        master to N1
> >>
> >> receive do assert msg
> >> form N3, but can not
> >> find lockres because
> >> DROPPING_REF is set,
> >> so the owner is still
> >> N2.
> >>
> >>                         receive deref from N1
> >>                         and response -EINVAL
> >>                         because lockres is migrated
> >>
> >> BUG when receive -EINVAL
> >> in dlm_drop_lockres_ref
> >>
> >> Fixes: 842b90b62461d ("ocfs2/dlm: return in progress if master can not clear the refmap bit right now")
> >>
> >> Link: http://lkml.kernel.org/r/57845103.3070406 at huawei.com
> >> Signed-off-by: Jun Piao <piaojun@huawei.com>
> >> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> >> Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
> > 
> > Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> > 
> > The only thing is I wonder if those ML_NOTICE messages in this patch and
> > the previous one will cause unnecessary end-user concern.
> > 
> > The fixes though look good, thanks for those.
> > 	--Mark
> > 
> > 
> Those ML_NOTICE log just server as reminders for developer, I think
> end-user usually care about ML_NOTICE log.

Ok, I had different experiences but it's not a big deal one way or the
other. If it helps you guys track what's going on then it's probably worth
it :)
	--Mark

--
Mark Fasheh
