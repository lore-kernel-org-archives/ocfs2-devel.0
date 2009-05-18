From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 18 May 2009 11:26:56 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242651759.20082.4.camel@localhost.localdomain>
References: <20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
	<1242651759.20082.4.camel@localhost.localdomain>
Message-ID: <20090518182656.GA8315@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andy Lutomirski <luto@mit.edu>, jmorris@namei.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 18, 2009 at 09:02:39AM -0400, Stephen Smalley wrote:
> For simplicity and robustness, I would only support the none or all
> flags, i.e. preserve can be a simple bool.  I don't think you really
> want to deal with the individual flags, and I don't see a use case for
> them.

	The simple use case I can think of is "I want a snapshot, but I
don't have rights to copy the MAC context".  Or "I want to own it, but I
want to keep all the ACLs for other users".
	Basically, if I'm adding another int argument to reflinkat(2), I
wanted to consider the future.  Maybe define it as 1 or 0, and leave the
use of the other bits for future possibilities?  If we're lucky, of
course, we never need future changes.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
