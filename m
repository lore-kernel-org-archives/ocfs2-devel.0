From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 10 Feb 2014 13:14:14 -0800
Subject: [Ocfs2-devel] [patch 10/11] ocfs2: fix issue
	that	ocfs2_setattr() does not deal with new_i_size==i_size
In-Reply-To: <20140124204710.C713531C1B6@corp2gmr1-1.hot.corp.google.com>
References: <20140124204710.C713531C1B6@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20140210211414.GU24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:47:10PM -0800, akpm at linux-foundation.org wrote:
> From: Younger Liu <younger.liu@huawei.com>
> Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size
> 
> The issue scenario is as following:
> 
> - Create a small file and fallocate a large disk space for a file with
>   FALLOC_FL_KEEP_SIZE option.
> 
> - ftruncate the file back to the original size again.  but the disk free
>   space is not changed back.  This is a real bug that be fixed in this
>   patch.
> 
> In order to solve the issue above, we modified ocfs2_setattr(), if
> attr->ia_size != i_size_read(inode), It calls ocfs2_truncate_file(), and
> truncate disk space to attr->ia_size.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
> Tested-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Sunil Mushran <sunil.mushran@gmail.com>
> Reviewed-by: Jensen <shencanquan@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This looks good, thanks for the fix Younger.
	--Mark

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
