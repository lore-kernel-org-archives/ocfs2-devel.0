From: Jan Kara <jack@suse.cz>
Date: Thu, 6 Nov 2014 07:46:50 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove pointless assignment in
 ocfs2_init()
In-Reply-To: <545AD6AA.8030007@huawei.com>
References: <1413903774-18825-1-git-send-email-jack@suse.cz>
	<545AD6AA.8030007@huawei.com>
Message-ID: <20141106064650.GA16833@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 06-11-14 10:02:18, Joseph Qi wrote:
> Does it mean we can ignore the failure of creating debugfs?
  Yes, generally it's the case that debugfs is optional and filesystem can
function without it just fine. OTOH looking more into where
ocfs2_debugfs_root is used, failure to create ocfs2_debugfs_root will lead
to debugfs entries being created in the root directory of debugfs
filesystem which is confusing to say the least. So for simplicity it's
probably better to just bail out with ENOMEM when we fail to create the
root. I'll send an updated patch. Thanks for review!

								Honza
> 
> On 2014/10/21 23:02, Jan Kara wrote:
> > Remove assignment which is never used.
> > 
> > Coverity-id: 1227009
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/super.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 93c85bc745e1..e1be0f0ea411 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -1621,10 +1621,8 @@ static int __init ocfs2_init(void)
> >  	}
> >  
> >  	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
> > -	if (!ocfs2_debugfs_root) {
> > -		status = -EFAULT;
> > +	if (!ocfs2_debugfs_root)
> >  		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
> > -	}
> >  
> >  	ocfs2_set_locking_protocol();
> >  
> > 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
