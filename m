From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 9 Apr 2013 13:09:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix error handling in
 ocfs2_ioctl_move_extents()
In-Reply-To: <51638854.8020405@oracle.com>
References: <51638854.8020405@oracle.com>
Message-ID: <20130409130948.a6ea97e8fd48c69a0389390c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 09 Apr 2013 11:17:40 +0800 Jeff Liu <jeff.liu@oracle.com> wrote:

> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Smatch complains that if we hit an error (for example if the file is
> immutable) then "range" has uninitialized stack data and we copy it to
> the user.
> 
> I've re-written the error handling to avoid this problem and make it a
> little cleaner as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>

I've added your signed-off-by to these patches - it should have been
included because you were on the patch delivery path.
