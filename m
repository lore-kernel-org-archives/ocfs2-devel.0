From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Mon, 18 May 2009 11:17:49 +0200
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090515205335.GB25787@mail.oracle.com>
References: <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
Message-ID: <20090518091749.GA23996@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, 15 May 2009 13:53:35 -0700, Joel Becker wrote:
> 
> 	Does this make everyone happy?

Provided the only fallback is to return an error code and let userspace
decide what to do, I'm a happy camper.

Not sure how many of the REFLINK_ATTR_* flags will actually be used,
apart from ALL and NONE.  But I don't mind having them.

J?rn

-- 
People will accept your ideas much more readily if you tell them
that Benjamin Franklin said it first.
-- unknown
