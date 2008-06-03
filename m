From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 3 Jun 2008 18:00:34 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 4/4] configfs: Make multiple
	default_group	destructions lockdep friendly
In-Reply-To: <20080602230721.GD19500@mail.oracle.com>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
Message-ID: <20080603160034.GA17308@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 04:07:21PM -0700, Joel Becker wrote:
> 	A couple comments.
> 	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
> be creating a depth we can't delete.

I think that the best way to avoid this is to use the same numbering scheme
while attaching default groups.

This would change the body of populate_groups() like this:

-	if (group->default_groups) {
+	/* lock_level starts at zero for the non default group.
+	 * Set it even if we do not take the lock, so that we can use the same
+	 * numbering scheme as for destruction time, and can prevent overload at
+	 * destruction time. */
+	lock_level = set_dirent_lock_level(parent_sd, sd);
+	if (lock_level < 0) {
+		/* Too many default groups */
+		ret = lock_level;
+	} else if (group->default_groups) {
 		/*
 		 * FYI, we're faking mkdir here
 		 * I'm not sure we need this semaphore, as we're called
 		 * from our parent's mkdir.  That holds our parent's
 		 * i_mutex, so afaik lookup cannot continue through our
 		 * parent to find us, let alone mess with our tree.
 		 * That said, taking our i_mutex is closer to mkdir
 		 * emulation, and shouldn't hurt.
 		 */
-		/* lock_level starts at zero for the non default group */
-		lock_level = set_dirent_lock_level(parent_sd, sd);
-		if (lock_level < 0) {
-			/* Too deeply nested default groups */
-			ret = lock_level;
-		} else {
 			mutex_lock_nested(&dentry->d_inode->i_mutex,
 					  I_MUTEX_CHILD + lock_level);
 
 			for (i = 0; group->default_groups[i]; i++) {
 				new_group = group->default_groups[i];
 
 				ret = create_default_group(group, new_group);
 				if (ret)
 					break;
 			}
 
 			mutex_unlock(&dentry->d_inode->i_mutex);
-			/* Reset for future sub-group creations */
-			reset_dirent_lock_level(sd);
-		}
 	}
+	if (lock_level > 0)
+		/* Update parent lock_level to keep it increasing, but not
+		 * if group is the one actually created/registered by the
+		 * user/subsystem */
+		copy_dirent_lock_level(sd, parent_sd);
+	/* Reset for future sub-group creations */
+	reset_dirent_lock_level(sd);

> 
> > @@ -392,6 +437,10 @@ static int configfs_detach_prep(struct d
> >  			 * deep nesting of default_groups
> >  			 */
> >  			ret = configfs_detach_prep(sd->s_dentry);
> > +			/* Update parent's lock_level so that remaining
> > +			 * sibling children keep on globally increasing
> > +			 * lock_level */
> > +			copy_dirent_lock_level(sd, parent_sd);
> >  			if (!ret)
> >  				continue;
> >  		} else
> 
> 	I'm not sure I get this hunk.  If our parent was 1 and we are 2,
> we are copying 2 to our parent so the parent can only have other
> children at 3?

Exactly.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
