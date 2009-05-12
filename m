From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Tue, 12 May 2009 13:31:52 +0200
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090511204011.GB30293@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
Message-ID: <20090512113152.GE6585@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 11 May 2009 13:40:11 -0700, Joel Becker wrote:
>
> 	Here's v4 of reflink().  If you have the privileges, you get the
> full snapshot.  If you don't, you must have read access, and then you
> get the entire snapshot (data and extended attributes) except that the
> security context is reinitialized.  That's it.  It fits with most of the
> other ops, and it's a clean degradation.

Let me see if I understand this correctly.  File "/tmp/foo" belongs to
Joel, file "/tmp/bar" belongs to Joern.  Everyone has read access to
those files.  Now if you reflink them to your home directory, both files
belong to you.  If I reflink them to my home directory, both files
belong to me.  And if root reflinks them to /root, one file belongs to
Joel, the other to Joern.  Is that correct?

Because if it is, I would call that behaviour rather confusing.  A
system call that behaves differently depending on who calls it - or
on whether the binary is installed suid root - is something I would like
to avoid.

J?rn

-- 
A surrounded army must be given a way out.
-- Sun Tzu
