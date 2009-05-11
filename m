From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 May 2009 15:34:14 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
Message-ID: <20090511223414.GA28209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, May 12, 2009 at 08:27:17AM +1000, James Morris wrote:
> On Mon, 11 May 2009, Joel Becker wrote:
> 
> > and other security attributes (in all, I'm gonna call that the "security
> > context") as well.  So I defined reflink() as such.  This meant
> 
> "security context" is an term associated with SELinux, so you may want to 
> use something like "security attributes" or "security state" to avoid 
> confusing people.

	Ok, I wondered if my brain had picked that out from somewhere.

> > +	error = security_inode_reflink(old_dentry, dir);
> > +	if (error)
> > +		return error;
> 
> We'll need the new_dentry now, to set up new security state before the 
> dentry is instantiated.
> 
> e.g. SELinux will need to perform some checks on the operation, then 
> calculate a new security context for the new file.

	Do I need to pass in preserve_security as well so SELinux knows
what the ownership check determined?

Joel

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
