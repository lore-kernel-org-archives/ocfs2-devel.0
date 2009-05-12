From: James Morris <jmorris@namei.org>
Date: Tue, 12 May 2009 11:12:04 +1000 (EST)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090511223414.GA28209@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
Message-ID: <alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 11 May 2009, Joel Becker wrote:

> > e.g. SELinux will need to perform some checks on the operation, then 
> > calculate a new security context for the new file.
> 
> 	Do I need to pass in preserve_security as well so SELinux knows
> what the ownership check determined?

Not for SELinux -- its security attributes are orthogonal to DAC, and it 
will perform its own checks on them.

Other LSMs should operate similarly (there is also the CAP_CHOWN check 
which the LSM may hook), although if not, the flag can be added later if 
required.


- James
-- 
James Morris
<jmorris@namei.org>
