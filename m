From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Feb 27 17:36:20 2004
Subject: [Ocfs2-devel] Makefile and configure changes for 2.6 support
In-Reply-To: <403FCA30.6090807@intel.com>
References: <403FCA30.6090807@intel.com>
Message-ID: <20040227233607.GA16342@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 27, 2004 at 02:52:32PM -0800, John L. Villalovos wrote:
> This is a cumulative patch to provide support to the build system for 
> building OCFS2 for 2.6.
<snip>
> +AC_ARG_ENABLE(kernel-2_6, AS_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) 
> Enable building on Linux kernel version 2.6.x 
> (default=no)]),enable_kernel26=yes,enable_kernel26=no)
> +OCFS_KERNEL_2_6=
> +if test "x$enable_kernel26" = "xyes"; then
> +  OCFS_KERNEL_2_6=yes
> +fi
> +AC_SUBST(OCFS_KERNEL_2_6)
> +

What version of autoconf are you using?  My v2.57 on my Fedora Core 1 box
doesn't understand AS_HELP_STRING.

[rusty@penguin b]$ autoconf
configure.in:86: error: possibly undefined macro: AS_HELP_STRING
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
 
