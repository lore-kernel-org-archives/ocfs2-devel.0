From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sat Jul 31 02:01:31 2004
Subject: [Ocfs2-devel] [Patch] use asynchronous journal commit in
	ocfs_rename
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404FFE536@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404FFE536@pdsmsx403>
Message-ID: <20040731070125.GD8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 29, 2004 at 08:36:54AM +0800, Ling, Xiaofeng wrote:
> Use asynchronous commit in ocfs_rename can make the speed of rename
> from  95dir/s to 11834dir/s.
Cool. the patch looks good at first glance. Would you be interested in
taking it one step further and doing the same for the last couple sync
transactions?  (link, truncate, and symlink)

Basically the same thing you just did here. The best thing in fact would  be
to just get rid of those flags (and the code which acts on them) altogether.

It's about time we got rid of that junk.
	--Mark

> ------------------------------------------------------------------------
> ---------------------
>  Index: namei.c
> ===================================================================
> --- namei.c     (revision 1312)
> +++ namei.c     (working copy)
> @@ -1049,6 +1049,8 @@
>                 goto bail;
>         }
> 
> +       ocfs_handle_set_checkpoint(handle, 0);
> +       ocfs_handle_set_sync(handle, 0);
>         /* if old and new are the same, this'll just do one lock. */
>         status = ocfs_double_lock(osb, handle,
>                                   OCFS_LKM_EXMODE,
> @@ -1084,6 +1086,9 @@
>                 LOG_ERROR_STATUS(status);
>                 goto finally;
>         }
> +
> +       ocfs_handle_add_lock(handle, OCFS_LKM_EXMODE,
> +                            FLAG_FILE_CREATE | FLAG_DIR, old_inode);
>         got_oldlock = 1;
> 
>         if (S_ISDIR(old_inode->i_mode)) {
> @@ -1157,6 +1162,8 @@
>                 }
>                 got_newlock = 1;
> 
> +               ocfs_handle_add_lock(handle, OCFS_LKM_EXMODE,
> +                            FLAG_FILE_CREATE | FLAG_DIR, new_inode);
>                 /* if our caching is working right, then after the
>                  * verify_update_inode, newfe->i_nlink ==
>                  * new_inode->i_nlink */
> @@ -1294,16 +1301,7 @@
>         status = 0;
> 
>  bail:
> -       if (got_oldlock) {
> -               ocfs_release_lock(osb, OCFS_LKM_EXMODE, oldfe_flags,
> -                                 old_inode);
> -       }
> 
> -       if (got_newlock) {
> -               ocfs_release_lock(osb, OCFS_LKM_EXMODE, newfe_flags,
> -                                 new_inode);
> -       }
> -
>         double_up_write(&OCFS_I(old_dir)->ip_io_sem,
>                         &OCFS_I(new_dir)->ip_io_sem);
>         up_write(&OCFS_I(old_inode)->ip_io_sem);
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
