From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 15 Aug 2012 00:34:00 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
 mlog_error
In-Reply-To: <20120815063710.GA31083@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1306514092-22962-1-git-send-email-tiger.yang@oracle.com>
	<20110601014303.GA5468@noexit.corp.google.com>
	<4DE714FC.9060903@oracle.com>
	<20120815063710.GA31083@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <20120815073359.GK31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 14, 2012 at 11:37:11PM -0700, Joel Becker wrote:
> On Thu, Jun 02, 2011 at 12:43:40PM +0800, Tiger Yang wrote:
> > On 06/01/2011 09:43 AM, Joel Becker wrote:
> > >On Sat, May 28, 2011 at 12:34:52AM +0800, Tiger Yang wrote:
> > >>We have already mlog all error and positive status is not error.
> > >	Positive status is turned into -EIO.  There are actually a
> > >couple of places in this function that do not mlog_errno(status) and
> > >rely on this print.  I think you should add them to your patch.
> > >	For example:
> > >
> > >371         status = ocfs2_qinfo_lock(oinfo, 0);
> > >372         if (status<  0)
> > >373                 goto out_unlock;
> > >
> > >Joel
> > >
> > >
> > Hi, Joel,
> > There is something devious about this function.
> > 1 If status == sizeof(struct ocfs2_global_disk_dqinfo)) then
> > positive status will be return.
> > 2 After goto out_unlock, they goto out_err again.
> > I make a new one to fix this.  please review the attached patch.
> > 
> > Thanks,
> > Tiger
> > 
> > 
> 
> > >From 36951746bb68250ce13a62fd2a3290fa8af30c54 Mon Sep 17 00:00:00 2001
> > From: Tiger Yang <tiger.yang@oracle.com>
> > Date: Thu, 2 Jun 2011 11:27:11 +0800
> > Subject: [PATCH 1/1] ocfs2: remove redundant and incorrect mlog_error
> > 
> > We have already mlog all error and positive status is not error.
> > 
> > Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> 
> This patch is now part of the fixes branch of ocfs2.git.

I lied.  It conflicted and did not get pushed.  This is still not
correct.  Removing mlog_errno() calls means we can't find out which line
caused the problem.

Joel

> 
> Joel
> 
> > ---
> >  fs/ocfs2/quota_global.c |   11 +++--------
> >  1 files changed, 3 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> > index 92fcd57..cb0f017 100644
> > --- a/fs/ocfs2/quota_global.c
> > +++ b/fs/ocfs2/quota_global.c
> > @@ -358,10 +358,8 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
> >  	oinfo->dqi_gqi_count = 0;
> >  	oinfo->dqi_gqinode = gqinode;
> >  	status = ocfs2_lock_global_qf(oinfo, 0);
> > -	if (status < 0) {
> > -		mlog_errno(status);
> > +	if (status < 0)
> >  		goto out_err;
> > -	}
> >  
> >  	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
> >  					     &pcount, NULL);
> > @@ -381,7 +379,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
> >  		     status);
> >  		if (status >= 0)
> >  			status = -EIO;
> > -		mlog_errno(status);
> >  		goto out_err;
> >  	}
> >  	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
> > @@ -398,14 +395,12 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
> >  	schedule_delayed_work(&oinfo->dqi_sync_work,
> >  			      msecs_to_jiffies(oinfo->dqi_syncms));
> >  
> > -out_err:
> > -	if (status)
> > -		mlog_errno(status);
> >  	return status;
> >  out_unlock:
> >  	ocfs2_unlock_global_qf(oinfo, 0);
> > +out_err:
> >  	mlog_errno(status);
> > -	goto out_err;
> > +	return status;
> >  }
> >  
> >  /* Write information to global quota file. Expects exlusive lock on quota
> > -- 
> > 1.7.4.4
> > 
> 
> 
> -- 
> 
> "The opposite of a correct statement is a false statement. The
>  opposite of a profound truth may well be another profound truth."
>          - Niels Bohr 
> 
> 			http://www.jlbec.org/
> 			jlbec at evilplan.org
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

			http://www.jlbec.org/
			jlbec at evilplan.org
