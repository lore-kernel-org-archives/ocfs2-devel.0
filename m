From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 27 Oct 2015 12:40:13 -0400
Subject: [Ocfs2-devel] [PATCH v3 3/7] selinux: Get rid of
	file_path_has_perm
In-Reply-To: <1445894128-6765-4-git-send-email-agruenba@redhat.com>
References: <1445894128-6765-1-git-send-email-agruenba@redhat.com>
	<1445894128-6765-4-git-send-email-agruenba@redhat.com>
Message-ID: <562FA8ED.7020704@tycho.nsa.gov>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, ocfs2-devel@oss.oracle.com, David Howells <dhowells@redhat.com>

On 10/26/2015 05:15 PM, Andreas Gruenbacher wrote:
> Use path_has_perm directly instead.

This reverts:

commit 13f8e9810bff12d01807b6f92329111f45218235
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jun 13 23:37:55 2013 +0100

     SELinux: Institute file_path_has_perm()

     Create a file_path_has_perm() function that is like path_has_perm() but
     instead takes a file struct that is the source of both the path and the
     inode (rather than getting the inode from the dentry in the path). 
  This
     is then used where appropriate.

     This will be useful for situations like unionmount where it will be
     possible to have an apparently-negative dentry (eg. a fallthrough) 
that is
     open with the file struct pointing to an inode on the lower fs.

     Signed-off-by: David Howells <dhowells@redhat.com>
     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

which I think David was intending to use as part of his 
SELinux/overlayfs support.

path_has_perm() uses d_backing_inode(path->dentry), while 
file_path_has_perm() uses file_inode(file).

>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>   security/selinux/hooks.c | 18 +++---------------
>   1 file changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 65e8689..d6b4dc9 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1673,18 +1673,6 @@ static inline int path_has_perm(const struct cred *cred,
>   	return inode_has_perm(cred, inode, av, &ad);
>   }
>
> -/* Same as path_has_perm, but uses the inode from the file struct. */
> -static inline int file_path_has_perm(const struct cred *cred,
> -				     struct file *file,
> -				     u32 av)
> -{
> -	struct common_audit_data ad;
> -
> -	ad.type = LSM_AUDIT_DATA_PATH;
> -	ad.u.path = file->f_path;
> -	return inode_has_perm(cred, file_inode(file), av, &ad);
> -}
> -
>   /* Check whether a task can use an open file descriptor to
>      access an inode in a given way.  Check access to the
>      descriptor itself, and then use dentry_has_perm to
> @@ -2371,14 +2359,14 @@ static inline void flush_unauthorized_files(const struct cred *cred,
>   			struct tty_file_private *file_priv;
>
>   			/* Revalidate access to controlling tty.
> -			   Use file_path_has_perm on the tty path directly
> +			   Use path_has_perm on the tty path directly
>   			   rather than using file_has_perm, as this particular
>   			   open file may belong to another process and we are
>   			   only interested in the inode-based check here. */
>   			file_priv = list_first_entry(&tty->tty_files,
>   						struct tty_file_private, list);
>   			file = file_priv->file;
> -			if (file_path_has_perm(cred, file, FILE__READ | FILE__WRITE))
> +			if (path_has_perm(cred, &file->f_path, FILE__READ | FILE__WRITE))
>   				drop_tty = 1;
>   		}
>   		spin_unlock(&tty_files_lock);
> @@ -3537,7 +3525,7 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
>   	 * new inode label or new policy.
>   	 * This check is not redundant - do not remove.
>   	 */
> -	return file_path_has_perm(cred, file, open_file_to_av(file));
> +	return path_has_perm(cred, &file->f_path, open_file_to_av(file));
>   }
>
>   /* task security operations */
>
