From: Jan Kara <jack@suse.cz>
Date: Mon, 2 Mar 2009 10:23:38 +0100
Subject: [Ocfs2-devel] [PATCH 6/7] vfs: Set special lockdep map for dirs
	only if not	set by fs
In-Reply-To: <1235680042.4948.590.camel@laptop>
References: <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
	<1235679305-3920-5-git-send-email-jack@suse.cz>
	<1235679305-3920-6-git-send-email-jack@suse.cz>
	<1235679305-3920-7-git-send-email-jack@suse.cz>
	<1235680042.4948.590.camel@laptop>
Message-ID: <20090302092338.GA23880@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 26-02-09 21:27:22, Peter Zijlstra wrote:
> On Thu, 2009-02-26 at 21:15 +0100, Jan Kara wrote:
> > Some filesystems need to set lockdep map for i_mutex differently for
> > different directories. For a filesystem it is naturaly done when the
> > inode is read but we have to modify unlock_new_inode() not to overwrite
> > the lockdep map filesystem has set.
> 
> This sounds very dubious.. are you really saying there are distinctly
> different locking rules for different directories within a single
> filesystem?
  Yes.

> That's insane..
  Not that much - the difference is between "system directories" and normal
directories. Currently we also have xattr i_mutex rank differently than
normal i_mutex and this is exactly the same case. Only OCFS2 has much more
such system files and also system directories so it's impractical to learn
VFS about all of them...
  But yes, probably I should update the changelog to say this so that
a reader does not have to look up why we need it.
 
> As to the patch, I'd rather you introduce a helper,
> lockdep_match_class() or somesuch, if you can convince VFS folks that
> what you're wanting to do is sane.
  OK, sounds good. Does something like:
#define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->dep_map, key)

and

int lockdep_match_key(struct lockdep_map *lock, struct lock_class_key *key)
{
	return lock->key == key;
}

  Look fine to you? Thanks for opinion.

									Honza

> > CC: peterz at infradead.org
> > CC: mingo at redhat.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/inode.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 913ab2d..c8c36cf 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -640,12 +640,16 @@ void unlock_new_inode(struct inode *inode)
> >  	if (inode->i_mode & S_IFDIR) {
> >  		struct file_system_type *type = inode->i_sb->s_type;
> >  
> > -		/*
> > -		 * ensure nobody is actually holding i_mutex
> > -		 */
> > -		mutex_destroy(&inode->i_mutex);
> > -		mutex_init(&inode->i_mutex);
> > -		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
> > +		/* Set new key only if filesystem haven't already changed it */
> > +		if (inode->i_mutex.dep_map.key != &type->i_mutex_key) {
> > +			/*
> > +			 * ensure nobody is actually holding i_mutex
> > +			 */
> > +			mutex_destroy(&inode->i_mutex);
> > +			mutex_init(&inode->i_mutex);
> > +			lockdep_set_class(&inode->i_mutex,
> > +					  &type->i_mutex_dir_key);
> > +		}
> >  	}
> >  #endif
> >  	/*
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
