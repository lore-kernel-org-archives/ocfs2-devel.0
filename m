From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 13 Jun 2014 14:21:14 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: manually do the iput once
	ocfs2_add_entry	failed in ocfs2_symlink and ocfs2_mknod
In-Reply-To: <539AC1DC.7010201@huawei.com>
References: <539AC1DC.7010201@huawei.com>
Message-ID: <20140613212114.GL5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good, thanks for fixing this up.

On Fri, Jun 13, 2014 at 05:18:20PM +0800, jiangyiwen wrote:
> When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
> ocfs2_mknod(), iput() will not be called during dput(dentry) because no
> d_instantiate(), and this will lead to umount hung.
> 
> Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
