From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 26 Jan 2020 09:35:06 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: remove FS_OCFS2_NM
In-Reply-To: <1579577812-251572-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579577812-251572-1-git-send-email-alex.shi@linux.alibaba.com>
Message-ID: <693015a3-5ead-9cd6-e95b-5b246722166b@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 20/1/21 11:36, Alex Shi wrote:
> This macro is't used from commit ab09203e302b ("sysctl fs: Remove
> dead binary sysctl support"). Better to remove it.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com> 
> Cc: Joel Becker <jlbec@evilplan.org> 
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com> 
> Cc: ocfs2-devel at oss.oracle.com 
> Cc: linux-kernel at vger.kernel.org

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/stackglue.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 8aa6a667860c..a191094694c6 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -656,8 +656,6 @@ static int ocfs2_sysfs_init(void)
>   * and easier to preserve the name.
>   */
>  
> -#define FS_OCFS2_NM		1
> -
>  static struct ctl_table ocfs2_nm_table[] = {
>  	{
>  		.procname	= "hb_ctl_path",
> 
