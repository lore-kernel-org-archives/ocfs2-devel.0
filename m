From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 4 Jul 2008 13:12:29 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 1/2] configfs: Prevent
	userspace	from creating new entries under attaching directories
In-Reply-To: <20080703215856.GG1502@mail.oracle.com>
References: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com>
	<1214503549-15678-2-git-send-email-louis.rilling@kerlabs.com>
	<20080703215856.GG1502@mail.oracle.com>
Message-ID: <20080704111229.GG30545@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Jul 03, 2008 at 02:58:56PM -0700, Joel Becker wrote:
> On Thu, Jun 26, 2008 at 08:05:48PM +0200, Louis Rilling wrote:
> > This commit fixes 1/, tagging new directories with CONFIGFS_USET_CREATING before
> > building the inode and instantiating the dentry, and validating the whole
> > group+default groups hierarchy in a second pass by clearing
> > CONFIGFS_USET_CREATING.
> 
> 	Man, I'm wary of all these in-flight flags.  I hope they are all
> orthogonal :-)

Yes they are :)

> 
> > 	mkdir(), symlink(), lookup(), and dir_open() simply return -ENOENT if
> > called in (or linking to) a directory tagged with CONFIGFS_USET_CREATING. This
> 
> 	Why not block until the create is done?

Hm, I think that we can't without risking deadlocks.

- mkdir(): we can only hit CONFIGFS_USET_CREATING when called inside a default
  group A/.../B of a new group A being attached. We hold B's i_mutex from
  sys_mkdirat(). We must not block because this could deadlock with
  detach_groups() in case the new group A fails to attach all its default
  groups.
- symlink(): same issue as mkdir(), plus the fact that it is not possible to
  block on the target of symlink(), because of potential deadlocks with
  lock_rename().
- lookup(): same issue as mkdir().
- dir_open(): same issue as mkdir().

> 
> > +	/*
> > +	 * Fake invisibility if dir belongs to a group/default groups hierarchy
> > +	 * being attached
> > +	 *
> > +	 * This forbids userspace to read/write attributes of items which may
> > +	 * not complete their initialization, since the dentries of the
> > +	 * attributes won't be instantiated.
> > +	 */
> int configfs_dirent_is_ready(struct configfs_dirent *sd)
> {
> 	int err = 0;
> > +	spin_lock(&configfs_dirent_lock);
> > +	if (parent_sd->s_type & CONFIGFS_USET_CREATING)
> > +		err = -ENOENT;
> > +	spin_unlock(&configfs_dirent_lock);
> 	return err;
> }
> 
> 	Then use is_ready() in the five places you check it ;-)  Perhaps
> change configfs_validate_dir() to configfs_dir_set_ready().  I do like
> the way validate_dir() is coded.

Ok. I'll resend the patchset with this change.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080704/1f2ff9d3/attachment.bin 
