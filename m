From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Apr 16 13:30:56 2007
Subject: [Ocfs2-devel] [PATCH] enable building as SUSE KMP
In-Reply-To: <4623BB1C.30101@suse.com>
References: <4623BB1C.30101@suse.com>
Message-ID: <20070416203052.GI27857@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 16, 2007 at 02:06:20PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> Starting with SLE 10 and openSUSE 10.2, the "right" way of building kernel
> modules for SUSE Linux systems is via the kernel module package (KMP) mechanism.

	Slickness.  Do all SLES10 versions, including GA, support this?
I hope so, it means we never have to create vendor/sles10.

> With the KMP infrastructure, if allowed, 'make packages' should work without even
> running configure since it runs configure for each kernel it builds against.

	You still need to run configure in the outer tree, because that
is what substitutes @VERSION@ etc.  That's all it does, however.  The
vendor trees, as you probably have noted, are designed to run "make
packages" on any system, regardless of where configure was run.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
