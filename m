From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2009 12:19:11 +0100
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Remove bogus link
	count	decrement
In-Reply-To: <1231912615.6716.16.camel@tristan-laptop.cn.oracle.com>
References: <1231798833-6850-1-git-send-email-jack@suse.cz>
	<1231798833-6850-2-git-send-email-jack@suse.cz>
	<1231798833-6850-3-git-send-email-jack@suse.cz>
	<1231798833-6850-4-git-send-email-jack@suse.cz>
	<1231798833-6850-5-git-send-email-jack@suse.cz>
	<1231798833-6850-6-git-send-email-jack@suse.cz>
	<1231912615.6716.16.camel@tristan-laptop.cn.oracle.com>
Message-ID: <20090114111911.GA19950@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 14-01-09 13:56:55, tristan.ye wrote:
> On Mon, 2009-01-12 at 23:20 +0100, Jan Kara wrote:
> > In ocfs2_unlink() we decremented i_nlink three times for directories (instead
> > of just two times). This actually did not matter because we have
> > ocfs2_drop_inode() which decides whether the inode should be deleted based on a
> > flag but it's at least surprising for a link count to wrap...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/namei.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index 084aba8..892d5e7 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -888,8 +888,6 @@ static int ocfs2_unlink(struct inode *dir,
> >  	}
> >  
> >  	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> > -	if (S_ISDIR(inode->i_mode))
> > -		drop_nlink(dir);
> 
> I thought the logic of original ocfs2_unlink() has no problem, it seems
> just drop the link count 2 times to release reference count for  '.' and
> '..' in all for the deleting directory inode.
> 
> The code you've truncated is the logic to drop link count for its parent
> directory, and it's a REQUIRED action, you may see it as
> drop_nlink(inode) by mistake:-) ? 
  Yes, I've read the code wrong. Thanks for spotting this.

> Otherwise, VFS unlink() will hit a failure when deleting a dir which
> containes sub_dir entires.  Like following,
> 
> 1. mkdir a
> 
> 2. mkdir -p a/b
> 
> 3. rm -rf a
> rm: cannot remove directory `a/': Directory not empty
  Hmm, I was just testing on one level of directories so my testing didn't
reveal the problem. Sigh.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
