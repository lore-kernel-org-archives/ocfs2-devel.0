From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 20 Mar 2014 07:02:33 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix panic on kfree(xattr->name)
In-Reply-To: <5329EFC6.6070803@oracle.com>
References: <5328D286.2010209@oracle.com>
	<201403192155.IBI05253.OJQLOFVFSHFMtO@I-love.SAKURA.ne.jp>
	<5329EFC6.6070803@oracle.com>
Message-ID: <201403200702.BEG90604.VOHtQOFOSLMJFF@I-love.SAKURA.ne.jp>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com
Cc: tariq.x.saeed@oracle.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org

Thank you for testing.

Mark and Joel, would you pick up this patch via your tree?

Tariq Saeed wrote:
> The patch works. What is the plan for submitting to mainline?
> Thanks,
> -Tariq
> 
> On 03/19/2014 05:55 AM, Tetsuo Handa wrote:
> > Tariq Saeed wrote:
> >> This commit did not take into account the callers of this function who
> >> assume they need to kfree() the name. It causes panic in ocfs2 on create
> >> file. I am puzzled how did this commit got into the tree without changing
> >> the callsites to NOT call kfree anymore. Am I missing something?
> >
> > You are right. It is my mistake. I didn't realize that ocfs2 is calling kfree()
> > on the name field. Would you please test below patch?
> >
> > Regards.
> > ----------
> >>From 3940749700148f58265407987f813b773515661a Mon Sep 17 00:00:00 2001
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date: Wed, 19 Mar 2014 21:49:21 +0900
> > Subject: [PATCH] ocfs2: Fix panic on kfree(xattr->name)
> >
> > Commit 9548906b 'xattr: Constify ->name member of "struct xattr".' missed that
> > ocfs2 is calling kfree(xattr->name). As a result, kernel panic occurs upon
> > calling kfree(xattr->name) because xattr->name refers static constant names.
> > This patch removes kfree(xattr->name) from ocfs2_mknod() and ocfs2_symlink().
> >
> > Reported-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: <stable@vger.kernel.org> [3.12+]
> > ---
> >   fs/ocfs2/namei.c |    2 --
> >   1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index 3683643..feed025 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -450,7 +450,6 @@ leave:
> >
> >   	brelse(new_fe_bh);
> >   	brelse(parent_fe_bh);
> > -	kfree(si.name);
> >   	kfree(si.value);
> >
> >   	ocfs2_free_dir_lookup_result(&lookup);
> > @@ -1855,7 +1854,6 @@ bail:
> >
> >   	brelse(new_fe_bh);
> >   	brelse(parent_fe_bh);
> > -	kfree(si.name);
> >   	kfree(si.value);
> >   	ocfs2_free_dir_lookup_result(&lookup);
> >   	if (inode_ac)
> >
> 
