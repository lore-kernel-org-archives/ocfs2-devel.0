From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu May  3 15:25:16 2007
Subject: [Ocfs2-devel] [PATCH] enable building as SUSE KMP
In-Reply-To: <20070503221817.GP27857@ca-server1.us.oracle.com>
References: <4623BB1C.30101@suse.com>
	<20070503221817.GP27857@ca-server1.us.oracle.com>
Message-ID: <20070503222512.GQ27857@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 03, 2007 at 03:18:17PM -0700, Joel Becker wrote:
> On Mon, Apr 16, 2007 at 02:06:20PM -0400, Jeff Mahoney wrote:
> > With the KMP infrastructure, if allowed, 'make packages' should work without even
> > running configure since it runs configure for each kernel it builds against.
> > 
> 
> Jeff,
> 	I get this when running on a vanilla SLES10 system:
> 
> # make packages
> <snipped tar output>
> rpmbuild -bs --define "_sourcedir ." --define "_srcrpmdir ."
> ./vendor/suse-kmp/ocfs2.spec
> ln: creating symbolic link `arch/um/Kconfig.arch' to
> `/usr/src/linux-2.6.16.21-0.8/arch/um/Kconfig.i386': Permission denied
> error: Unable to open temp file.
> *** glibc detected *** rpmbuild: free(): invalid pointer: 0xb7efa630 ***
> ======= Backtrace: =========

<snip>

	Ok, running as root I don't get that problem.  However, I do see
this in the um build:

arch/um/include/sysdep/checksum.h: In function ?csum_and_copy_to_user?:
arch/um/include/sysdep/checksum.h:198: error: implicit declaration of
function ?access_ok_tt?

Joel

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
