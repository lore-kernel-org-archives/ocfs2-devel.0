From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Tue, 26 Nov 2013 14:40:22 -0800
Subject: [Ocfs2-devel] [PATCH] Remove versioning information
In-Reply-To: <20131126192850.GA17120@shrek.lan>
References: <20131126192850.GA17120@shrek.lan>
Message-ID: <CAEeiSHUDkkCM0szjHjUzHvjHf2H7Ot7EngKNC27bc5KM4nGT9Q@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

You may want to do the same for the version file in dlm, dlmfs, etc.


On Tue, Nov 26, 2013 at 11:28 AM, Goldwyn Rodrigues <rgoldwyn@suse.de>wrote:

> The versioning information is confusing for end-users. The numbers
> are stuck at 1.5.0 when the tools have moved to 1.8.3.
>
> I suggest removing the versioning system in the kernel altogether
> and let the kernel version be the guide to debug issues. However, if
> you think versioning is still required, please state the reason and
> modify the version string in the ver.* files to reflect the uptodate
> information.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/Makefile |  1 -
>  fs/ocfs2/super.c  |  3 ---
>  fs/ocfs2/ver.c    | 43 -------------------------------------------
>  fs/ocfs2/ver.h    | 31 -------------------------------
>  4 files changed, 78 deletions(-)
>  delete mode 100644 fs/ocfs2/ver.c
>  delete mode 100644 fs/ocfs2/ver.h
>
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index f17e58b..ce210d4 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -38,7 +38,6 @@ ocfs2-objs := \
>         symlink.o               \
>         sysfile.o               \
>         uptodate.o              \
> -       ver.o                   \
>         quota_local.o           \
>         quota_global.o          \
>         xattr.o                 \
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c414929..a4382d1 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -68,7 +68,6 @@
>  #include "super.h"
>  #include "sysfile.h"
>  #include "uptodate.h"
> -#include "ver.h"
>  #include "xattr.h"
>  #include "quota.h"
>  #include "refcounttree.h"
> @@ -1618,8 +1617,6 @@ static int __init ocfs2_init(void)
>  {
>         int status, i;
>
> -       ocfs2_print_version();
> -
>         for (i = 0; i < OCFS2_IOEND_WQ_HASH_SZ; i++)
>                 init_waitqueue_head(&ocfs2__ioend_wq[i]);
>
> diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
> deleted file mode 100644
> index e2488f4..0000000
> --- a/fs/ocfs2/ver.c
> +++ /dev/null
> @@ -1,43 +0,0 @@
> -/* -*- mode: c; c-basic-offset: 8; -*-
> - * vim: noexpandtab sw=8 ts=8 sts=0:
> - *
> - * ver.c
> - *
> - * version string
> - *
> - * Copyright (C) 2002, 2005 Oracle.  All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License as published by the Free Software Foundation; either
> - * version 2 of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/string.h>
> -#include <linux/kernel.h>
> -
> -#include "ver.h"
> -
> -#define OCFS2_BUILD_VERSION "1.5.0"
> -
> -#define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
> -
> -void ocfs2_print_version(void)
> -{
> -       printk(KERN_INFO "%s\n", VERSION_STR);
> -}
> -
> -MODULE_DESCRIPTION(VERSION_STR);
> -
> -MODULE_VERSION(OCFS2_BUILD_VERSION);
> diff --git a/fs/ocfs2/ver.h b/fs/ocfs2/ver.h
> deleted file mode 100644
> index d7395cb..0000000
> --- a/fs/ocfs2/ver.h
> +++ /dev/null
> @@ -1,31 +0,0 @@
> -/* -*- mode: c; c-basic-offset: 8; -*-
> - * vim: noexpandtab sw=8 ts=8 sts=0:
> - *
> - * ver.h
> - *
> - * Function prototypes
> - *
> - * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License as published by the Free Software Foundation; either
> - * version 2 of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#ifndef OCFS2_VER_H
> -#define OCFS2_VER_H
> -
> -void ocfs2_print_version(void);
> -
> -#endif /* OCFS2_VER_H */
> --
> 1.8.1.4
>
>
> --
> Goldwyn
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20131126/7c84c41c/attachment.html 
