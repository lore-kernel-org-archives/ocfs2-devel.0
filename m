From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Apr 16 11:18:47 2007
Subject: [Ocfs2-devel] [PATCH] use conditional for machine_restart()
In-Reply-To: <4623B745.1030007@suse.com>
References: <4623B745.1030007@suse.com>
Message-ID: <4623BE03.1020006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://oss.oracle.com/~smushran/.suse/o2cb-quorum_fence.patch

We'll be checking in the above soon. It avoids CFLAGS. Any objections?

Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> This patch handles the missing machine_restart() on some SUSE releases.
>
> - -Jeff
>
> diff -ruNp ocfs2-1.2.5/Config.make.in ocfs2-1.2.5.devel/Config.make.in
> - --- ocfs2-1.2.5/Config.make.in	2007-03-27 15:54:17.000000000 -0400
> +++ ocfs2-1.2.5.devel/Config.make.in	2007-04-16 13:00:54.357734412 -0400
> @@ -62,6 +62,7 @@ DIO_OLD_GET_BLOCKS = @DIO_OLD_GET_BLOCKS
>  STATFS_GETS_SB = @STATFS_GETS_SB@
>  INODE_HAS_BLKSIZE  = @INODE_HAS_BLKSIZE@
>  INODE_HAS_PRIVATE  = @INODE_HAS_PRIVATE@
> +HAS_MACHINE_RESTART  = @HAS_MACHINE_RESTART@
>  
>  BUILD_DEBUGFS_BACKPORT = @BUILD_DEBUGFS_BACKPORT@
>  BUILD_CONFIGFS = @BUILD_CONFIGFS@
> diff -ruNp ocfs2-1.2.5/configure.in ocfs2-1.2.5.devel/configure.in
> - --- ocfs2-1.2.5/configure.in	2007-03-27 15:54:17.000000000 -0400
> +++ ocfs2-1.2.5.devel/configure.in	2007-04-16 12:56:51.301364243 -0400
> @@ -273,6 +274,11 @@ OCFS2_CHECK_KERNEL([i_private field on s
>    INODE_HAS_PRIVATE=yes, , [i_private])
>  AC_SUBST(INODE_HAS_PRIVATE)
>  
> +HAS_MACHINE_RESTART=
> +OCFS2_CHECK_KERNEL([machine_restart], reboot.h,
> +   HAS_MACHINE_RESTART=yes, , [machine_restart])
> +AC_SUBST(HAS_MACHINE_RESTART)
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff -ruNp ocfs2-1.2.5/fs/ocfs2/cluster/Makefile ocfs2-1.2.5.devel/fs/ocfs2/cluster/Makefile
> - --- ocfs2-1.2.5/fs/ocfs2/cluster/Makefile	2007-03-27 15:54:16.000000000 -0400
> +++ ocfs2-1.2.5.devel/fs/ocfs2/cluster/Makefile	2007-04-16 12:59:43.332305221 -0400
> @@ -23,6 +23,10 @@ ifdef INET_SK_RETURNS_INET_OPT
>  EXTRA_CFLAGS += -DINET_SK_RETURNS_INET_OPT
>  endif
>  
> +ifdef HAS_MACHINE_RESTART
> +EXTRA_CFLAGS += -DHAS_MACHINE_RESTART
> +endif
> +
>  SOURCES =			\
>  	heartbeat.c		\
>  	masklog.c		\
> diff -ruNp ocfs2-1.2.5/fs/ocfs2/cluster/quorum.c ocfs2-1.2.5.devel/fs/ocfs2/cluster/quorum.c
> - --- ocfs2-1.2.5/fs/ocfs2/cluster/quorum.c	2007-03-27 15:54:16.000000000 -0400
> +++ ocfs2-1.2.5.devel/fs/ocfs2/cluster/quorum.c	2007-04-15 20:13:01.189599924 -0400
> @@ -81,7 +81,11 @@ static void o2quo_fence_self(void)
>  		panic("*** ocfs2 is very sorry to be fencing this system by panicing ***\n");
>  	default:
>  		printk("*** ocfs2 is very sorry to be fencing this system by restarting ***\n");
> +#ifdef HAS_MACHINE_RESTART
>  		machine_restart(NULL);
> +#else
> +		emergency_restart();
> +#endif
>  	}
>  }
>  
>
>
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.5 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org
>
> iD8DBQFGI7dELPWxlyuTD7IRAvOOAJ9sjawmGSfB8AYcCqtykZPCsSe2ywCfWcRq
> /sGmAIIXR+8BS1LRQQa7N8I=
> =ucIC
> -----END PGP SIGNATURE-----
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
