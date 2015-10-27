From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 27 Oct 2015 13:20:52 -0400
Subject: [Ocfs2-devel] [PATCH v3 2/7] selinux: Add accessor functions
 for inode->i_security
In-Reply-To: <1445894128-6765-3-git-send-email-agruenba@redhat.com>
References: <1445894128-6765-1-git-send-email-agruenba@redhat.com>
	<1445894128-6765-3-git-send-email-agruenba@redhat.com>
Message-ID: <562FB274.6080100@tycho.nsa.gov>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, ocfs2-devel@oss.oracle.com, David Howells <dhowells@redhat.com>

On 10/26/2015 05:15 PM, Andreas Gruenbacher wrote:
> Add functions dentry_security and inode_security for accessing
> inode->i_security.  These functions initially don't do much, but they
> will later be used to revalidate the security labels when necessary.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>   security/selinux/hooks.c | 101 ++++++++++++++++++++++++++---------------------
>   1 file changed, 57 insertions(+), 44 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index fc8f626..65e8689 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -241,6 +241,24 @@ static int inode_alloc_security(struct inode *inode)
>   	return 0;
>   }
>
> +/*
> + * Get the security label of a dentry's inode.
> + */
> +static struct inode_security_struct *dentry_security(struct dentry *dentry)
> +{
> +	struct inode *inode = d_backing_inode(dentry);
> +
> +	return inode->i_security;
> +}
> +
> +/*
> + * Get the security label of an inode.
> + */
> +static struct inode_security_struct *inode_security(struct inode *inode)
> +{
> +	return inode->i_security;
> +}
> +
>   static void inode_free_rcu(struct rcu_head *head)
>   {
>   	struct inode_security_struct *isec;
<snip>
> @@ -2207,7 +2222,6 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
>   	struct task_security_struct *new_tsec;
>   	struct inode_security_struct *isec;
>   	struct common_audit_data ad;
> -	struct inode *inode = file_inode(bprm->file);
>   	int rc;
>
>   	/* SELinux context only depends on initial program or script and not
> @@ -2217,7 +2231,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
>
>   	old_tsec = current_security();
>   	new_tsec = bprm->cred->security;
> -	isec = inode->i_security;
> +	isec = dentry_security(bprm->file->f_path.dentry);

IIUC, this could change which inode label gets used when using overlayfs 
(the overlay inode or the underlying inode).  Not sure whether the 
current code is correct for overlayfs (overlayfs + SELinux support still 
in progress).

> @@ -3154,7 +3168,7 @@ out_nofree:
>   static int selinux_inode_setsecurity(struct inode *inode, const char *name,
>   				     const void *value, size_t size, int flags)
>   {
> -	struct inode_security_struct *isec = inode->i_security;
> +	struct inode_security_struct *isec = inode_security(inode);

Was it intentional to not do this for selinux_inode_getsecurity() and 
selinux_inode_getsecid()?

> @@ -3241,8 +3254,8 @@ int ioctl_has_perm(const struct cred *cred, struct file *file,
>   {
>   	struct common_audit_data ad;
>   	struct file_security_struct *fsec = file->f_security;
> -	struct inode *inode = file_inode(file);
> -	struct inode_security_struct *isec = inode->i_security;
> +	struct dentry *dentry = file->f_path.dentry;
> +	struct inode_security_struct *isec = dentry_security(dentry);
>   	struct lsm_ioctlop_audit ioctl;
>   	u32 ssid = cred_sid(cred);
>   	int rc;
> @@ -3263,7 +3276,7 @@ int ioctl_has_perm(const struct cred *cred, struct file *file,
>   			goto out;
>   	}
>
> -	if (unlikely(IS_PRIVATE(inode)))
> +	if (unlikely(IS_PRIVATE(dentry->d_inode)))
>   		return 0;
>
>   	rc = avc_has_extended_perms(ssid, isec->sid, isec->sclass,
> @@ -3506,7 +3519,7 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
>   	struct inode_security_struct *isec;
>
>   	fsec = file->f_security;
> -	isec = file_inode(file)->i_security;
> +	isec = dentry_security(file->f_path.dentry);

Similarly for these cases, switching from file_inode(file) to 
d_backing_inode(dentry) could affect overlayfs interaction IIUC.  cc'd 
David for clarification.
