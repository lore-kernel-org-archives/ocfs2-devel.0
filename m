From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 13 Jun 2008 14:09:23 +0200
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613104513.GI30804@localhost>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
	<20080613104513.GI30804@localhost>
Message-ID: <20080613120923.GJ30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2008 at 12:45:13PM +0200, Louis Rilling wrote:
> 
> Unfortunately, thinking a bit more about it I found some issues with
> i_mutex lock free detach_prep(), but nothing that can't be fixed ;)
> 	Between detach_prep() in A and mkdir() in a default group A/B:
> detach_prep() can be called in the middle of attach_group(), for instance after
> having attached A/B/C, but attach_group() may then fail (because of memory
> pressure for instance) while attaching C's default group A/B/C/D. This would
> lead to both mkdir(A/B/C) and rmdir(A) failing, the reason for rmdir failure
> being at best obscure: the user would have expected to either see mkdir succeed
> and rmdir fail because of the new A/B/C group, or see mkdir fail and rmdir
> succeed because no user-created group lived under A. Solution: tag A/B with
> USET_IN_MKDIR on mkdir entrance, remove that tag on mkdir exit, and retry
> detach_prep() as long as USET_IN_MKDIR is found under A/*.
> 	Between rmdir() and readdir(): dir_open() might add a configfs_dirent
> to a default group A/B that detach_prep() already marked with USET_DROPPING.
> This could result in detach_groups() dropping the dirent and make readdir() in
> A/B crash afterwards. Solution: check USET_DROPPING in dir_open() and fail if
> it is set.
> 	Between rmdir() and lookup(): several lookup() called under A/* while
> rmdir(A) in the middle of detach_groups() could return inconsistent results (for
> instance some default groups being there and some other ones not). Solution:
> lock dirent_lock for the whole lookup() duration, check USET_DROPPING of current
> dir, and fail with ENOENT if it is set.

Oh, should probably provide some d_revalidate() also, which would return
-ENOENT for a dentry under a directory flagged with USET_DROPPING. But I'm
realizing that such "inconsistencies" (some default groups being valid in the
d_cache and some other ones not) already happen between the time detach_prep()
has flagged a default group with USET_DROPPING and the default
group is actually detached. Am I wrong?

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080613/4f400cd4/attachment-0001.bin 
