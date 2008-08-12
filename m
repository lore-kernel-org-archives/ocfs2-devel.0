From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 12 Aug 2008 12:25:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2console: Allow ocfs2console
	to	enumerate device mapper devices
In-Reply-To: <48A1A9C7.1080906@suse.com>
References: <48A1A9C7.1080906@suse.com>
Message-ID: <20080812192523.GA11744@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[Cc'ing ocfs2-tools-devel]

On Tue, Aug 12, 2008 at 11:18:31AM -0400, Jeff Mahoney wrote:
>  ocfs2console will currently display device mapper devices as dm-#, where
>  the number can be dynamic across reboots making it non-obvious which
>  device the user is using. While LVM volumes aren't safe to use across
>  physical nodes, they are often used with virtual machines. Many ocfs2
>  users also use dm-multipath.
> 
>  This patch refactors partition_info_fill to separate hashing from
>  enumeration so that it is trivial to add a device-mapper enumerator.
> 
>  The device mapper enumerator is automatically enabled if libdevmapper
>  is present at build time. When enabled, it suppresses the dm-# devices
>  from enumeration. If disabled, the dm-# devices are used instead.
> 
>  I have a bug report for this (Novell Bugzilla 414756) and it was easy
>  enough to bang out quickly.

	Nice!  I've not played with libdevmapper - I assume that the
enumerator returns "preferred" names when there are 10 different
symlinks for the same volume?  :-)

Joel

> +LIBDEVMAPPER_FOUND=
> +AC_CHECK_HEADER(libdevmapper.h, LIBDEVMAPPER_FOUND=yes,
> +  [AC_MSG_WARN([libdevmapper.h not found, device-mapper support will not be built])])
> +AC_SUBST(LIBDEVMAPPER_FOUND)

	Please check for the lib too:

LIBDEVMAPPER_FOUND=
AC_CHECK_LIB(devmapper, dm_task_create,
  [AC_CHECK_HEADER(libdevmapper.h, LIBDEVMAPPER_FOUND=yes,
    [AC_MSG_WARN([libdevmapper.h not found, device-mapper support will not be built])])],
  [AC_MSG_WARN([libdevmapper not found, device-mapper support will not
be built])])
AC_SUBST(LIBDEVMAPPER_FOUND)

Otherwise, it looks good.

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
