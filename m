From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 19 Jun 2013 21:12:59 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: llseek need to require ocfs2
 inode lock for updating the size in SEEK_END
In-Reply-To: <51C18A31.40008@huawei.com>
References: <51C18A31.40008@huawei.com>
Message-ID: <51C1AE5B.9090402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Canquan,

On 06/19/2013 06:38 PM, shencanquan wrote:

> The test scenario is following:
> 
> There are two node, one is nodeA, another is nodeB
> On nodeA, the test program open the file and write some data to the
> file and then close the file.
> On nodeB, the another test program open the file and llseek the end of
> file. we found that the position of file is old.
> 
> After apply this patch. it is ok on nodeB. the position of file is
> update to date.

But I still not get a direct viewing.  That is to say the currently
incorrect behavior as well as the correct result with this fix up.
This would be useful not only for the patch reviewer but also can be
proved that your fix is really works as expected.

That is not hard to wrap up the test code and results into the patch
commit log, e.g,

On nodeA:
---------
1) Record the test file size
2) Append the test file && close it

On nodeB:
---------
1) Open/seek to the end of the test file and record/verify the result.

You can write the test code in any language that you preferred. e.g, use
python to verify the SEEK_END result with this patch:

$ python -c "import os;f=open('test_file_path_name', 'r');f.seek(0, 2); \
             fsize=f.tell();print fsize"

> 
> Signed-off-by: jensen <shencanquan@huawei.com>
> ---
>  fs/ocfs2/file.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ff54014..f2570ba 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>  	case SEEK_SET:
>  		break;
>  	case SEEK_END:
> +		/* SEEK_END requires the OCFS2 inode lock because
> +		 * it uses the inode size.

The comments is wrong.  In general, the inode size means that how
many bytes is used to store an inode in file system blocks.

I'd like to suggest the comments below:
		/* SEEK_END requires the OCFS2 inode lock for the
		 * file because it references the file's size.
		 */

Hi Mark, what's your opinion?

> +		*/

		^^ <-- No alignment to above lines.

> +		ret = ocfs2_inode_lock(inode, NULL, 0);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
>  		offset += inode->i_size;
> +		ocfs2_inode_unlock(inode, 0);
>  		break;
>  	case SEEK_CUR:
>  		if (offset == 0) {


Thanks,
-Jeff
