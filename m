From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 15 Jun 2013 13:09:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix llseek() semantics and do
	some cleanup
In-Reply-To: <1371237814-59365-2-git-send-email-ryao@gentoo.org>
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
	<1371237814-59365-2-git-send-email-ryao@gentoo.org>
Message-ID: <51BBF6FE.6080502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Yao <ryao@gentoo.org>
Cc: Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, kernel@gentoo.org, linux-fsdevel@vger.kernel.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>

[Add ocfs2-devel to CC-list]

Hello Richard,

Thanks for your patch.

On 06/15/2013 03:23 AM, Richard Yao wrote:

> There are multiple issues with the custom llseek implemented in ocfs2 for
> implementing SEEK_HOLE/SEEK_DATA.
> 
> 1. It takes the inode->i_mutex lock before calling generic_file_llseek(), which
> is unnecessary.

Agree, but please see my comments below.

> 
> 2. It fails to take the filp->f_lock spinlock before modifying filp->f_pos and
> filp->f_version, which differs from generic_file_llseek().
> 
> 3. It does a offset > inode->i_sb->s_maxbytes check that permits seeking up to
> the maximum file size possible on the ocfs2 filesystem, even when it is past
> the end of the file. Seeking beyond that (if possible), would return EINVAL
> instead of ENXIO.
> 
> 4. The switch statement tries to cover all whence values when in reality it
> should only care about SEEK_HOLE/SEEK_DATA. Any other cases should be passsed
> to generic_file_llseek().

I have another patch set for refactoring ocfs2_file_llseek() but not yet found time
to run a comprehensive tests.  It can solve the existing issues but also improved the
SEEK_DATA/SEEK_HOLE for unwritten extents, i.e. OCFS2_EXT_UNWRITTEN.

With this change, SEEK_DATA/SEEK_HOLE will go into separate function with a little code
duplication instead of the current mix-ups in ocfs2_seek_data_hole_offset(), i.e, 

loff_t ocfs2_file_llseek()
{
	switch (origin) {
        case SEEK_END:
        case SEEK_CUR:
        case SEEK_SET:
                return generic_file_llseek(file, offset, origin);
        case SEEK_DATA:
                return ocfs2_seek_data(file, offset);
        case SEEK_HOLE:
                return ocfs2_seek_hole(file, offset);
        default:
                return -EINVAL;
        }
}

I personally like keeping SEEK_DATA/SEEK_HOLE in switch...case style rather
than dealing with them in a condition check block.

Thanks,
-Jeff

> 
> btrfs_file_llseek() and ocfs2_file_llseek() are extremely similar and
> consequently, contain many of the same flaws. Li Dongyang filed a pull
> request with ZFSOnLinux for SEEK_HOLE/SEEK_DATA support that included a
> custom llseek function that appears to have been modelled after the one
> in ocfs2. The similarity was strong enough that it suffered from many of
> the same flaws, which I caught during review. I addressed the issues
> with his patch with one that I wrote. Since a small percentage of Gentoo
> Linux users are affected by these flaws, I decided to adapt that code
> that to btrfs (separate patch) and ocfs2.
> 
> Note that commit 48802c8ae2a9d618ec734a61283d645ad527e06c by Jeff Liu at
> Oracle mostly addressed #3 in btrfs. The only lingering issue was that
> the offset > inode->i_sb->s_maxbytes check became dead code. The ocfs2
> code was not fortunate enough to have had a similar correction until
> now.
> 
> Signed-off-by: Richard Yao <ryao@gentoo.org>
> ---
>  fs/ocfs2/file.c | 65 ++++++++++++++++++++++-----------------------------------
>  1 file changed, 25 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ff54014..84f8c9c 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2615,54 +2615,39 @@ bail:
>  }
>  
>  /* Refer generic_file_llseek_unlocked() */
> -static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
> +static loff_t ocfs2_file_llseek(struct file *filp, loff_t offset, int whence)
>  {
> -	struct inode *inode = file->f_mapping->host;
> -	int ret = 0;
> +	if (whence == SEEK_DATA || whence == SEEK_HOLE) {
> +		struct inode *inode = filp->f_mapping->host;
> +		int ret;
>  
> -	mutex_lock(&inode->i_mutex);
> +		if (offset < 0 && !(filp->f_mode & FMODE_UNSIGNED_OFFSET))
> +			return -EINVAL;
>  
> -	switch (whence) {
> -	case SEEK_SET:
> -		break;
> -	case SEEK_END:
> -		offset += inode->i_size;
> -		break;
> -	case SEEK_CUR:
> -		if (offset == 0) {
> -			offset = file->f_pos;
> -			goto out;
> +		if (offset >= i_size_read(inode)) {
> +			return -ENXIO;
>  		}
> -		offset += file->f_pos;
> -		break;
> -	case SEEK_DATA:
> -	case SEEK_HOLE:
> -		ret = ocfs2_seek_data_hole_offset(file, &offset, whence);
> -		if (ret)
> -			goto out;
> -		break;
> -	default:
> -		ret = -EINVAL;
> -		goto out;
> -	}
>  
> -	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
> -		ret = -EINVAL;
> -	if (!ret && offset > inode->i_sb->s_maxbytes)
> -		ret = -EINVAL;
> -	if (ret)
> -		goto out;
> +		mutex_lock(&inode->i_mutex);
> +		ret = ocfs2_seek_data_hole_offset(filp, &offset, whence);
> +		mutex_unlock(&inode->i_mutex);
> +
> +		if (ret) {
> +			return ret;
> +		}
>  
> -	if (offset != file->f_pos) {
> -		file->f_pos = offset;
> -		file->f_version = 0;
> +		if (offset != filp->f_pos) {
> +			spin_lock(&filp->f_lock);
> +			filp->f_pos = offset;
> +			filp->f_version = 0;
> +			spin_unlock(&filp->f_lock);
> +		}
> +
> +		return offset;
>  	}
>  
> -out:
> -	mutex_unlock(&inode->i_mutex);
> -	if (ret)
> -		return ret;
> -	return offset;
> +	return generic_file_llseek(filp, offset, whence);
> +
>  }
>  
>  const struct inode_operations ocfs2_file_iops = {
