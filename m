From: James Morris <jmorris@namei.org>
Date: Fri, 8 May 2009 11:39:53 +1000 (EST)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090507221535.GA31624@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com>
Message-ID: <alpine.LRH.2.00.0905081124540.2761@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org

On Thu, 7 May 2009, Joel Becker wrote:


> @@ -1402,6 +1419,8 @@ struct security_operations {
>  			  struct dentry *new_dentry);
>  	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
>  			    struct path *new_dir, struct dentry *new_dentry);
> +	int (*path_reflink) (struct dentry *old_dentry, struct path *new_dir,
> +			     struct dentry *new_dentry);
>  #endif
>  

The TOMOYO folk don't need a path hook, so it would be unused, and should 
not be added unless someone responsible for an in-tree LSM establishes a 
case for it.

> +int security_inode_reflink(struct dentry *old_dentry, struct inode *dir,
> +			   struct dentry *new_dentry);

We don't need the new_dentry argument (this is correct in the low-level 
hook, and doesn't compile with CONFIG_SECURITY=y).


- James
-- 
James Morris
<jmorris@namei.org>
