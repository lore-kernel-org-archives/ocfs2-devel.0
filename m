From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 25 Jun 2008 19:12:09 -0700
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080625095527.GB32036@hawkmoon.kerlabs.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
	<20080624180456.GA32036@hawkmoon.kerlabs.com>
	<20080624213439.GB2785@mail.oracle.com>
	<20080625095527.GB32036@hawkmoon.kerlabs.com>
Message-ID: <20080626021208.GA21801@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 25, 2008 at 11:55:27AM +0200, Louis Rilling wrote:
> Back to the two solutions that I've suggested (copy-pasted below), which one
> would you prefer?

	God, this is all ugly.  You've found so many ugly cases :-(

> If I'm right, two kinds of solutions for issue 1 (new item created while
> attaching a default group hierarchy):
> i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate, and
> validate the whole group+default groups hierarchy in a second pass by clearing
> CONFIGFS_USET_NEW

	I think this is the right way.  We can't d_instantiate() later,
because lower callers use dentry->d_inode, and trying to work around
that would be even uglier!
	But can't we just propagate CONFIGFS_USET_MKDIR?  That's what's
happening actually.  Just set it down in the paths.  Then, change like
so:

	if (group)
        	ret = configfs_attach_group(parent_item, item, dentry);
	else
        	ret = configfs_attach_item(parent_item, item, dentry);
 
	spin_lock(&configfs_dirent_lock);
	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	if (!ret)
+		configfs_clear_mkdir_flag(dentry);
	spin_unlock(&configfs_dirent_lock);

Right?

> For issue 2/ (detach_item() called without locking the detached item's inode),
> locking the inode before calling detach_item() (as is done from
> configfs_rmdir()), plus a solution for 1/ should be sufficient.

	Make sure you lock/unlock in the right place (mirror the
teardown path).

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
