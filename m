From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 18:49:16 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <alpine.LRH.2.00.0905081124540.2761@tundra.namei.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com>
	<alpine.LRH.2.00.0905081124540.2761@tundra.namei.org>
Message-ID: <20090508014916.GG31624@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org

On Fri, May 08, 2009 at 11:39:53AM +1000, James Morris wrote:
> On Thu, 7 May 2009, Joel Becker wrote:
> 
> 
> > @@ -1402,6 +1419,8 @@ struct security_operations {
> >  			  struct dentry *new_dentry);
> >  	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
> >  			    struct path *new_dir, struct dentry *new_dentry);
> > +	int (*path_reflink) (struct dentry *old_dentry, struct path *new_dir,
> > +			     struct dentry *new_dentry);
> >  #endif
> >  
> 
> The TOMOYO folk don't need a path hook, so it would be unused, and should 
> not be added unless someone responsible for an in-tree LSM establishes a 
> case for it.

	Oh, I misread what they said:

> TOMOYO wants to prevent reflink(".htpasswd", "readme.html").
> But security_path_mknod() can't know the source file's name.
> Therefore, TOMOYO wants security_path_link() rather than security_path_mknod().
> So far I don't feel TOMOYO needs to introduce security_path_reflink() > because
> modifications after reflink() will be checked by other LSM hooks.

	So I should change the path_reflink() call to path_link() in
reflinkat(2)?

> > +int security_inode_reflink(struct dentry *old_dentry, struct inode *dir,
> > +			   struct dentry *new_dentry);
> 
> We don't need the new_dentry argument (this is correct in the low-level 
> hook, and doesn't compile with CONFIG_SECURITY=y).

	Eek, missed that.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
