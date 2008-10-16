From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Oct 2008 01:20:42 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Add POSIX ACLs
	support	in ocfs2
In-Reply-To: <1224143394-30970-1-git-send-email-tiger.yang@oracle.com>
References: <48F6F0A3.5060909@oracle.com>
	<1224143394-30970-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081016082042.GA22345@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 16, 2008 at 03:49:54PM +0800, Tiger Yang wrote:
> diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
> index 4340cc8..578209c 100644
> --- a/Documentation/filesystems/ocfs2.txt
> +++ b/Documentation/filesystems/ocfs2.txt
> @@ -28,13 +28,11 @@ Manish Singh  <manish.singh@oracle.com>
>  Caveats
>  =======
>  Features which OCFS2 does not support yet:
> -	- extended attributes
>  	- quotas
>  	- cluster aware flock
>  	- cluster aware lockf

	These two (flock/lockf) are now supported thanks to Mark.

>  	- Directory change notification (F_NOTIFY)
>  	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
> -	- POSIX ACLs
...
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> new file mode 100644
> index 0000000..a0ff81c
> --- /dev/null
> +++ b/fs/ocfs2/acl.c
> @@ -0,0 +1,528 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * acl.c
> + *
> + * Copyright (C) 2008 Oracle.  All rights reserved.
> + *
> + * CREDITS:
> + * Lots of code in this file is taken from ext3.

	You should mention the copyright on that ext3 code:

 * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>

It's his code you are copying, with his copyright.

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.

> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.

	Leave out the last paragraph.  They've moved, and they recommend
leaving out the address.

Joel

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
