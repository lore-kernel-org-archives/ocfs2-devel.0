From: Sage Weil <sage@newdream.net>
Date: Tue, 19 May 2009 09:32:33 -0700 (PDT)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090518182656.GA8315@mail.oracle.com>
References: <20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
	<1242651759.20082.4.camel@localhost.localdomain>
	<20090518182656.GA8315@mail.oracle.com>
Message-ID: <Pine.LNX.4.64.0905190914340.22458@cobra.newdream.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi Joel,

This version (with whatever flag simplifications are deemed appropriate) 
looks pretty good to me!

The only other thing I would like to see is a flag that makes copying the 
xattrs optional.  That's straying toward kitchen sink territory, but it 
seems like a natural enough interface once you're cherry-picking what to 
preserve in the reflink.  (Since you can always remove unwanted xattrs 
later, of course, it's certainly not a show-stopper.)

Thanks!
sage
