From: Manish Singh <manish.singh@oracle.com>
Date: Tue Mar  2 17:47:44 2004
Subject: [Ocfs2-devel] Updated Patch for 2.6 Make system
In-Reply-To: <40450AC7.1060507@intel.com>
References: <40450AC7.1060507@intel.com>
Message-ID: <20040302234739.GA2650@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 02:29:27PM -0800, John L. Villalovos wrote:
> Fixes an error from the previous patch where I forgot to do NPTL :(
> 
> This now compiles with SVN revision 748.

I just committed a modified version of the configure.in and Config.make.in
changes.

> Index: configure.in
> ===================================================================
> --- configure.in	(revision 747)
> +++ configure.in	(working copy)
> @@ -83,6 +83,13 @@
>    AC_MSG_ERROR(GCC is required)
>  fi
> 
> +AC_ARG_ENABLE(kernel-2_6, AC_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) 
> Enable building on Linux kernel version 2.6.x 
> (default=no)]),enable_kernel26=yes,enable_kernel26=no)
> +OCFS_KERNEL_2_6=
> +if test "x$enable_kernel26" = "xyes"; then
> +  OCFS_KERNEL_2_6=yes
> +fi
> +AC_SUBST(OCFS_KERNEL_2_6)

I got rid of the _'s. configure's never use _ in switches. Also, we can't
use AC_HELP_STRING since we still need to support AS 2.1, which ships with
ancient autoconf 2.13.

> +      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this 
> time!  Your system WILL hang.])

Used AC_MSG_WARN instead of AC_MSG_NOTICE for the same reason.

> @@ -314,4 +331,5 @@
>  vendor/unitedlinux/ocfs2-2.4.21-107.spec
>  vendor/unitedlinux/ocfs2-2.4.21-111.spec
>  vendor/unitedlinux/ocfs2-2.4.21-138.spec
> +src/Makefile-2.6

In makebo philosophy, Makefiles should never be generated from .in's. You
should be able to include Config.make for what you need.

What I'd like to see is having one Makefile that does everything, with the
defines, cflags, and object files defined only once. Keeping this in sync
across multiple files is a maintainence headache.

-Manish
