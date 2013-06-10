From: Casey Schaufler <casey@schaufler-ca.com>
Date: Mon, 10 Jun 2013 08:53:47 -0700
Subject: [Ocfs2-devel] [PATCH] xattr: Constify ->name member of "struct
	xattr".
In-Reply-To: <201306082154.BDJ95357.MFQFVOJLSOtHFO@I-love.SAKURA.ne.jp>
References: <201305292152.CCF10933.FQJHFLOtOFVMSO@I-love.SAKURA.ne.jp>
	<201306082154.BDJ95357.MFQFVOJLSOtHFO@I-love.SAKURA.ne.jp>
Message-ID: <51B5F68B.6060008@schaufler-ca.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, eparis@parisplace.org, zohar@us.ibm.com, serge.hallyn@canonical.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>

On 6/8/2013 5:54 AM, Tetsuo Handa wrote:
> >From 96df8b4be7f8702913a0245b2312958e2eea6caf Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sat, 8 Jun 2013 21:46:58 +0900
> Subject: [PATCH] xattr: Constify ->name member of "struct xattr".
>
> Since everybody sets kstrdup()ed constant string to "struct xattr"->name but
> nobody modifies "struct xattr"->name , we can omit kstrdup() and its failure
> checking by constifying ->name member of "struct xattr".
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Unnecessary data duplication and memory allocation is bad.
Thanks for catching this.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  fs/ocfs2/xattr.h                    |    2 +-
>  include/linux/security.h            |    8 ++++----
>  include/linux/xattr.h               |    2 +-
>  include/uapi/linux/reiserfs_xattr.h |    2 +-
>  security/capability.c               |    2 +-
>  security/integrity/evm/evm_main.c   |    2 +-
>  security/security.c                 |    8 +++-----
>  security/selinux/hooks.c            |   17 ++++++-----------
>  security/smack/smack_lsm.c          |    9 +++------
>  9 files changed, 21 insertions(+), 31 deletions(-)
>
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index e5c7f15..19f134e 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -32,7 +32,7 @@ enum ocfs2_xattr_type {
>  
>  struct ocfs2_security_xattr_info {
>  	int enable;
> -	char *name;
> +	const char *name;
>  	void *value;
>  	size_t value_len;
>  };
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 40560f4..2e64d73 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1466,7 +1466,7 @@ struct security_operations {
>  	int (*inode_alloc_security) (struct inode *inode);
>  	void (*inode_free_security) (struct inode *inode);
>  	int (*inode_init_security) (struct inode *inode, struct inode *dir,
> -				    const struct qstr *qstr, char **name,
> +				    const struct qstr *qstr, const char **name,
>  				    void **value, size_t *len);
>  	int (*inode_create) (struct inode *dir,
>  			     struct dentry *dentry, umode_t mode);
> @@ -1737,7 +1737,7 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
>  				 const struct qstr *qstr,
>  				 initxattrs initxattrs, void *fs_data);
>  int security_old_inode_init_security(struct inode *inode, struct inode *dir,
> -				     const struct qstr *qstr, char **name,
> +				     const struct qstr *qstr, const char **name,
>  				     void **value, size_t *len);
>  int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
>  int security_inode_link(struct dentry *old_dentry, struct inode *dir,
> @@ -2048,8 +2048,8 @@ static inline int security_inode_init_security(struct inode *inode,
>  static inline int security_old_inode_init_security(struct inode *inode,
>  						   struct inode *dir,
>  						   const struct qstr *qstr,
> -						   char **name, void **value,
> -						   size_t *len)
> +						   const char **name,
> +						   void **value, size_t *len)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index fdbafc6..91b0a68 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -31,7 +31,7 @@ struct xattr_handler {
>  };
>  
>  struct xattr {
> -	char *name;
> +	const char *name;
>  	void *value;
>  	size_t value_len;
>  };
> diff --git a/include/uapi/linux/reiserfs_xattr.h b/include/uapi/linux/reiserfs_xattr.h
> index d8ce17c..38fdd64 100644
> --- a/include/uapi/linux/reiserfs_xattr.h
> +++ b/include/uapi/linux/reiserfs_xattr.h
> @@ -16,7 +16,7 @@ struct reiserfs_xattr_header {
>  };
>  
>  struct reiserfs_security_handle {
> -	char *name;
> +	const char *name;
>  	void *value;
>  	size_t length;
>  };
> diff --git a/security/capability.c b/security/capability.c
> index 1728d4e..b311ff0 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -119,7 +119,7 @@ static void cap_inode_free_security(struct inode *inode)
>  }
>  
>  static int cap_inode_init_security(struct inode *inode, struct inode *dir,
> -				   const struct qstr *qstr, char **name,
> +				   const struct qstr *qstr, const char **name,
>  				   void **value, size_t *len)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index cdbde17..2787080 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -405,7 +405,7 @@ int evm_inode_init_security(struct inode *inode,
>  
>  	evm_xattr->value = xattr_data;
>  	evm_xattr->value_len = sizeof(*xattr_data);
> -	evm_xattr->name = kstrdup(XATTR_EVM_SUFFIX, GFP_NOFS);
> +	evm_xattr->name = XATTR_EVM_SUFFIX;
>  	return 0;
>  out:
>  	kfree(xattr_data);
> diff --git a/security/security.c b/security/security.c
> index a3dce87..8849691 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -335,10 +335,10 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
>  	if (unlikely(IS_PRIVATE(inode)))
>  		return 0;
>  
> -	memset(new_xattrs, 0, sizeof new_xattrs);
>  	if (!initxattrs)
>  		return security_ops->inode_init_security(inode, dir, qstr,
>  							 NULL, NULL, NULL);
> +	memset(new_xattrs, 0, sizeof(new_xattrs));
>  	lsm_xattr = new_xattrs;
>  	ret = security_ops->inode_init_security(inode, dir, qstr,
>  						&lsm_xattr->name,
> @@ -353,16 +353,14 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
>  		goto out;
>  	ret = initxattrs(inode, new_xattrs, fs_data);
>  out:
> -	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
> -		kfree(xattr->name);
> +	for (xattr = new_xattrs; xattr->value != NULL; xattr++)
>  		kfree(xattr->value);
> -	}
>  	return (ret == -EOPNOTSUPP) ? 0 : ret;
>  }
>  EXPORT_SYMBOL(security_inode_init_security);
>  
>  int security_old_inode_init_security(struct inode *inode, struct inode *dir,
> -				     const struct qstr *qstr, char **name,
> +				     const struct qstr *qstr, const char **name,
>  				     void **value, size_t *len)
>  {
>  	if (unlikely(IS_PRIVATE(inode)))
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 5c6f2cd..16b8e51 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2516,7 +2516,8 @@ static void selinux_inode_free_security(struct inode *inode)
>  }
>  
>  static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
> -				       const struct qstr *qstr, char **name,
> +				       const struct qstr *qstr,
> +				       const char **name,
>  				       void **value, size_t *len)
>  {
>  	const struct task_security_struct *tsec = current_security();
> @@ -2524,7 +2525,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  	struct superblock_security_struct *sbsec;
>  	u32 sid, newsid, clen;
>  	int rc;
> -	char *namep = NULL, *context;
> +	char *context;
>  
>  	dsec = dir->i_security;
>  	sbsec = dir->i_sb->s_security;
> @@ -2560,19 +2561,13 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  	if (!ss_initialized || !(sbsec->flags & SE_SBLABELSUPP))
>  		return -EOPNOTSUPP;
>  
> -	if (name) {
> -		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
> -		if (!namep)
> -			return -ENOMEM;
> -		*name = namep;
> -	}
> +	if (name)
> +		*name = XATTR_SELINUX_SUFFIX;
>  
>  	if (value && len) {
>  		rc = security_sid_to_context_force(newsid, &context, &clen);
> -		if (rc) {
> -			kfree(namep);
> +		if (rc)
>  			return rc;
> -		}
>  		*value = context;
>  		*len = clen;
>  	}
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d52c780..46e5b47 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -554,7 +554,7 @@ static void smack_inode_free_security(struct inode *inode)
>   * Returns 0 if it all works out, -ENOMEM if there's no memory
>   */
>  static int smack_inode_init_security(struct inode *inode, struct inode *dir,
> -				     const struct qstr *qstr, char **name,
> +				     const struct qstr *qstr, const char **name,
>  				     void **value, size_t *len)
>  {
>  	struct smack_known *skp;
> @@ -564,11 +564,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  	char *dsp = smk_of_inode(dir);
>  	int may;
>  
> -	if (name) {
> -		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_NOFS);
> -		if (*name == NULL)
> -			return -ENOMEM;
> -	}
> +	if (name)
> +		*name = XATTR_SMACK_SUFFIX;
>  
>  	if (value) {
>  		skp = smk_find_entry(csp);
