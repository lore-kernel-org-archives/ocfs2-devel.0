From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Oct  7 23:47:35 2004
Subject: [Ocfs2-devel] configure.in makes baby Zach cry
In-Reply-To: <4165C3EB.4060605@oracle.com>
References: <4165C3EB.4060605@oracle.com>
Message-ID: <20041008044726.GD27633@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 07, 2004 at 03:32:11PM -0700, Zach Brown wrote:
> if test "x$rhkernel" = "xyes"; then
>   if test "$OCFS_PROCESSOR" = "i686"; then
>     KVER=up
>   else
>     KVER=smp

	With Red Hat kernels in RHEL3, you pick which distro kernel
flavor (up, smp, etc) is the default build.  However, your athlon has a
KVER of athlon.  Just run "make KVER=athlon".  At least, that's my
guess.  That is, unless FC2 has dropped the KVER thing (very possible)
and configure.in needs to learn to be like SuSE for FC2.

Joel

-- 

"The whole principle is wrong; it's like demanding that grown men 
 live on skim milk because the baby can't eat steak."
        - author Robert A. Heinlein on censorship

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
