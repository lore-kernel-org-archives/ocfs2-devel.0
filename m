From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 18 Sep 2013 11:58:14 +0300
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing errno in
	ocfs2_ioctl_move_extents()
In-Reply-To: <52396549.6040906@huawei.com>
References: <52396549.6040906@huawei.com>
Message-ID: <20130918085813.GS19256@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 18, 2013 at 04:33:13PM +0800, Younger Liu wrote:
> If the file is not regular or writeable, it should return errno(-EPERM).
> 
> This patch is based on commit 85a258b70d4891a443583530f48ab734a31e2d8d.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
