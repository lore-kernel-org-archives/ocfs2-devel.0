From: Manish Singh <manish.singh@oracle.com>
Date: Sat Aug 20 15:48:10 2005
Subject: [Ocfs2-devel] Small fixes for ocfs2-tools 1.1.1
In-Reply-To: <20050820141934.GM4436@marowsky-bree.de>
References: <20050820141934.GM4436@marowsky-bree.de>
Message-ID: <20050820204812.GA4469@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 20, 2005 at 04:19:34PM +0200, Lars Marowsky-Bree wrote:
> Hi,
> 
> I'm just building ocfs2-tools 1.1.1 (bleeding edge ;-) for openSUSE.
> 
> Attached you'll find two patches.
> 
> One fixes obvious mistakes in configure.in as well as an uninitialized
> variable being dereferenced.
> 
> The second one I'm not sure about whether you want to take it upstream.
> If linking against com_err, you need to also link against pthread now.

What changed to require this? That sounds kind of broken, and isn't
reflected in upstream e2fsprogs.
 
> In our specfile, I also had to move debugfs.ocfs2 and ocfs2cdsl from
> /sbin to /usr/sbin, because they link against glib, which is not on /,
> and thus our build system doesn't like binaries on / linked against
> that.

How about moving glib to / ? ;)
 
> The third attachment are the remaining signedness warnings the compiler
> generates. I've glanced at a few, and they seem harmless (except maybe
> the one in dump.c?), but you may want to clean them up...

Yeah, gcc4 spews like mad now...

> --- configure.in	(revision 1063)
> +++ configure.in	(working copy)
> @@ -84,7 +84,7 @@
>  
>  UUID_LIBS=
>  AC_CHECK_LIB(uuid, uuid_unparse, UUID_LIBS=-luuid)
> -if test "x$COM_ERR_LIBS" = "x"; then
> +if test "x$UUID_LIBS" = "x"; then
>    AC_MSG_ERROR([Unable to find uuid library])
>  fi
>  AC_CHECK_HEADER(uuid/uuid.h, :,

Cut'n'paste screw up. Thanks for noticing, this is applied to SVN.

-Manish
