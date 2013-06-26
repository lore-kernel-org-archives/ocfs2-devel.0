From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Jun 2013 14:18:03 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <51C2BC1F.2010106@huawei.com>
References: <51C2BC1F.2010106@huawei.com>
Message-ID: <20130626141803.a67cb8e4ca38a9ef2967a448@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 20 Jun 2013 16:23:59 +0800 shencanquan <shencanquan@huawei.com> wrote:

> llseek requires ocfs2 inode lock for updating the file size in SEEK_END.
> because the file size maybe update on another node.
> if it not . after call llseek in SEEK_END. the position is old.
> 
> this bug can be reproduce the following scenario:
> at first ,we dd a test fileA,the file size is 10k.
> on NodeA:
> ---------
> 1) open the test fileA, lseek the end of file. and print the position.
> 2) close the test fileA
> 
> on NodeB:
> 1) open the test fileA, append the 5k data to test FileA.
> 2) lseek the end of file. and print the position.
> 3) close file.
> 
> at first we run the test program1 on NodeA , the result is 10k.
> and then run the test program2 on NodeB,  the result is 15k.
> at last, we run the test program1 on NodeA again, the result is 10k.
> 
> after apply this patch.  the three step result is 15k.
> 
> ...
>
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>  	case SEEK_SET:
>  		break;
>  	case SEEK_END:
> +		/* SEEK_END requires the OCFS2 inode lock for the file
> +		 * because it references the file's size.
> +		 */
> +		ret = ocfs2_inode_lock(inode, NULL, 0);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
>  		offset += inode->i_size;
> +		ocfs2_inode_unlock(inode, 0);
>  		break;

I don't understand this.  The lock for inode->i_size is inode->i_mutex,
and we're already holding i_mutex here.  The current mainline code
looks correct.

My guess is that there is some other code path which is modifying
inode->i_size without holding inode->i_mutex, and while holding
ocfs2_inode_lock().  If so, that code is surely wrong - it should hold
i_mutex while modifying i_size.

Also, safely reading i_size should be performed via i_size_read(), and
modifications to i_size should use i_size_write().

And all this is only really applicable to 32-bit CPUs, which you
probably aren't using.

So.... please let's take a second look at this.
