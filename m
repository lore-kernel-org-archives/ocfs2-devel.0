From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jun  8 14:15:03 2004
Subject: [Ocfs2-devel] [Patch] for bug 88, touch&chmod file cause hang.
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840492FCC5@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840492FCC5@pdsmsx403>
Message-ID: <20040608191457.GC4380@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah, I'll have a fix for this in svn soon. Right now it's actually just
better that you remove the down() / up() combination altogether in your
private tree. It shouldn't hurt anything as the buffer semaphore hash is
still enabled in svn.
	--Mark

On Tue, Jun 08, 2004 at 05:20:48PM +0800, Ling, Xiaofeng wrote:
> 
> When you touch a file, in the call sequence,
> sys_utime->notify_change->ocfs_setattr, before notify_change,
> there is a "down(&inode->i_sem)", so in ocfs_setattr, when down again,
> it causes dead lock.
> I guess it should use the priv_sem instead. see the patch, it can work.
> 
> Index: file.c
> ===================================================================
> --- file.c	(revision 1022)
> +++ file.c	(working copy)
> @@ -1347,7 +1347,7 @@
>  	/* NOTE: Other filesystems get away without locking this, but
>  	 * we're clustered and this has to hit disk now... */
>  	if (!(attr->ia_valid & ATTR_SIZE))
> -		down(&inode->i_sem);
> +		down (&(OCFS_I(inode)->priv_sem));
>  
>  	if (!dentry->d_parent || !dentry->d_parent->d_inode) {
>  		LOG_ERROR_STR ("bad inode or root inode");
> @@ -1449,7 +1449,7 @@
>  
>  bail:
>  	if (!(attr->ia_valid & ATTR_SIZE))
> -		up(&inode->i_sem);
> +		up (&(OCFS_I(inode)->priv_sem));
>  
>  #ifndef BH_SEM_LEAK_CHECKING
>  	if (error < 0)
> 
> bug 88 description
> 
> kernel 2.6.6
> mount a ocfs2 file system and then do:
> cd /ocfs
> touch /ocfs/a
> the command hangs. system not hang.
> 
> The call trace:
> 
> touch         D C036B74C     0  1593   1227                     (NOTLB)
> ccf4fe6c 00000082 00000246 c036b74c ccc9c484 00000000 d08cc25c d08cc25c 
>        cd1fa200 cfebf680 ccc9c484 00000001 cd086400 0001f061 805bbf22
> 000000b1 
>        cd8fefd8 cd1da868 00000286 cd8fee30 cd1da870 c0354af0 00000001
> cd8fee30 
> Call Trace:
>  [<d08cc25c>] ocfs_bh_sem_lookup+0x1d7/0x3ad [ocfs2]
>  [<d08cc25c>] ocfs_bh_sem_lookup+0x1d7/0x3ad [ocfs2]
>  [<c0354af0>] __down+0x7c/0xc7
>  [<c011269c>] default_wake_function+0x0/0x12
>  [<c0354c44>] __down_failed+0x8/0xc
>  [<d08cbe3f>] .text.lock.file+0x181/0x186 [ocfs2]
>  [<c015c95c>] notify_change+0x153/0x187
>  [<c0143ecb>] sys_utime+0x105/0x181
>  [<d08c6fd8>] ocfs_file_open+0x0/0x7aa [ocfs2]
>  [<d08c7b4f>] ocfs_file_release+0x3cd/0x415 [ocfs2]
>  [<c0146304>] __fput+0xa5/0xfb
>  [<c0103e5f>] syscall_call+0x7/0xb
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
