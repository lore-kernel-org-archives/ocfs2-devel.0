From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 06:05:00 +0100
Subject: [Ocfs2-devel] [PATCH 22/29] ocfs2: Let inode be really
	deleted	when ocfs2_mknod_locked() fails
In-Reply-To: <20081030235234.GO15154@wotan.suse.de>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861043323-git-send-email-jack@suse.cz>
	<20081030235234.GO15154@wotan.suse.de>
Message-ID: <20081031050500.GC4476@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 30-10-08 16:52:34, Mark Fasheh wrote:
> On Sat, Oct 25, 2008 at 12:08:15AM +0200, Jan Kara wrote:
> > We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
> > and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
> > space was not released). Fix it.
> 
> By the way, does ocfs2_delete_inode() complain when this can't be found in
> the orphan dir?
  If the allocation fails due to quota, inode is not really initialized so
it does not complain. Previously, when I did quota checks after allocation
of space, I saw some complaints about inode not being in orphan dir - yes.
But they are in fact false since we remove the inode in the same
transaction is which we allocated it so it cannot happen that it would be
left allocated in case of crash. So yeah, it might be nice to actually
tweak the code so that we can avoid the warning in case of error cleanup.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
