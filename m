From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 5 Feb 2015 14:03:40 -0800
Subject: [Ocfs2-devel] [patch 1/4] ocfs2: prune the dcache before
	deleting the dentry	of directory
In-Reply-To: <54d2b2af.vngP6L5LZDv1pKQH%akpm@linux-foundation.org>
References: <54d2b2af.vngP6L5LZDv1pKQH%akpm@linux-foundation.org>
Message-ID: <20150205220340.GD21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2015 at 04:00:47PM -0800, Andrew Morton wrote:
> From: alex chen <alex.chen@huawei.com>
> Subject: ocfs2: prune the dcache before deleting the dentry of directory
> 
> In ocfs2_dentry_convert_worker, we should prune the dcache before deleting
> the dentry of directory, otherwise, in the following cases the inode of
> directory will still remain in orphan directory until the device being
> umounted.

... 

> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: joyce.xue <xuejiufei@huawei.com>

Looks good, thanks Alex!

Reviewed-by: Mark Fasheh <mfasheh@suse.com>
