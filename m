From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 17 Jun 2013 23:17:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek need to inode cluster lock
 and unlock for update the inode size in SEEK_END.
In-Reply-To: <51BF21D6.9080008@huawei.com>
References: <51BF21D6.9080008@huawei.com>
Message-ID: <51BF289D.9030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shencanquan <shencanquan@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On 06/17/2013 10:48 PM, shencanquan wrote:

> We found that llseek has a bug when in SEEK_END.  it need to add the 
> inode lock and unlock.
> This bug can be reproduce the following scenario:
> On one nodeA, open the file and then write some data to file and close 
> the file .
> On another nodeB , open the file and llseek the end of file . the 
> position of file is old.

Can you please wrap these around 72 columns or so in the future?
Also, that would be appreciated if you can supply more detailed
info to reflect the results before/after applying this patch.

> 
> Signed-off-by: jensen <shencanquan@huawei.com>
> ---
>   file.c |    7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/file.c b/file.c
> index ff54014..4ee7c80 100644
> --- a/file.c
> +++ b/file.c
> @@ -2626,6 +2626,13 @@ static loff_t ocfs2_file_llseek(struct file 
> *file, loff_t offset, int whence)
>       case SEEK_SET:
>           break;
>       case SEEK_END:
> +        /*need to inode lock and unlock for update the inode size.*/

Please add spaces between comments and annotation, i.e,
	   /*  Need to ...... */

> +        ret = ocfs2_inode_lock(inode, NULL, 0);
> +        if (ret < 0) {
> +            mlog_errno(ret);
> +            goto out;
> +        }
> +        ocfs2_inode_unlock(inode, 0);
>           offset += inode->i_size;

Why not protect the offset adjustment insides ocfs2 inode locks?

>           break;
>       case SEEK_CUR:

Looks your email client has not configured properly for posting patches
because all those changes are not using tab for code indentation, please
refer to Documentation/email-clients.txt for detail if so.

-Jeff
