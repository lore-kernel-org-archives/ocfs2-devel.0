From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Jun 2008 14:15:23 -0700
Subject: [Ocfs2-devel] [BUG] deadlock between configfs_rmdir() and
	sys_rename() (WAS	Re: [RFC][PATCH 4/4] configfs: Make
	multiple default_group)	destructions lockdep friendly
In-Reply-To: <20080611173047.GR18153@localhost>
References: <20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
	<20080609110353.GK18153@localhost>
	<20080609125443.GL18153@localhost>
	<20080610015800.GD14820@mail.oracle.com>
	<20080610101427.GA4048@localdomain>
	<20080610173654.GA23829@ca-server1.us.oracle.com>
	<20080611141010.GP18153@localhost>
	<20080611173047.GR18153@localhost>
Message-ID: <20080611211523.GB14754@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 07:30:47PM +0200, Louis Rilling wrote:
> I've spoken too fast. Doing things in d_revalidate() (or even in
> configfs_lookup()) is just too early: after they are called and before
> lock_rename(), nothing can prevent rmdir() from being called.

	Yeah, that's what I was saying.

> I'm afraid that we need a way to get rid of the whole tree locking in
> configfs_detach_prep(). Imagine that we protect all calls to configfs_rmdir()
> and configfs_mkdir() with a global mutex (say configfs_dir_mutex). Is it still
> needed to take default group's i_mutex in configfs_detach_prep() to check for
> the validity of the rmdir()?

	That's not a bad idea.  I was basically sure we need the tree
locking to prevent other VFS operations from happening, but the more I
think about it, the only reason we do the prep locking is to check and
protect the ENOTEMPTY case.  I've bounced it off Mark too, and he
agrees.

> 	After this check, we could set a REMOVING flag in configfs_dirent of all
> default groups (could actually be done by configfs_detach_prep(), making
> configfs_detach_rollback() resetting the flag), release configfs_dir_mutex, and
> then call configfs_detach_group(), with detach_groups() taking default group's
> i_mutex right before calling configfs_detach_group() recursively (this would
> lead to the same path locking as in populate_groups() or
> configfs_depend_prep()).

	We already set the flag - CONFIGFS_USET_DROPPING.  The only
change is that you don't take i_mutex anymore.  For the static mutex,
the name 'configfs_dir_mutex' is fine.

> 	On mkdir() side, once configfs_dir_mutex is acquired, we first check the
> REMOVING flag, and proceed if it is not set.

	And if it is set, we return -ENOENT.

> Just tell me if you think that it's feasible, and I'll send you a patch if it's

	Have at!  Thanks.

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
