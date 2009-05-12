From: jim owens <jowens@hp.com>
Date: Tue, 12 May 2009 09:12:17 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090512113152.GE6585@logfs.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<20090512113152.GE6585@logfs.org>
Message-ID: <4A0975B1.90703@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

J?rn Engel wrote:
> On Mon, 11 May 2009 13:40:11 -0700, Joel Becker wrote:
>> 	Here's v4 of reflink().  If you have the privileges, you get the
>> full snapshot.  If you don't, you must have read access, and then you
>> get the entire snapshot (data and extended attributes) except that the
>> security context is reinitialized.  That's it.  It fits with most of the
>> other ops, and it's a clean degradation.
> 
> Let me see if I understand this correctly.  File "/tmp/foo" belongs to
> Joel, file "/tmp/bar" belongs to Joern.  Everyone has read access to
> those files.  Now if you reflink them to your home directory, both files
> belong to you.  If I reflink them to my home directory, both files
> belong to me.  And if root reflinks them to /root, one file belongs to
> Joel, the other to Joern.  Is that correct?

yes

> Because if it is, I would call that behaviour rather confusing.  A
> system call that behaves differently depending on who calls it - or
> on whether the binary is installed suid root - is something I would like
> to avoid.

Avoiding that just gives us other confusing operations unless
you have a really good alternative.

This design is very elegant, I wish I had thought of it :)

It passes the test that 99% of the time for any user (including
root), "it just works the way I want it to".  In my experience,
root and setuid programs really don't want to take ownership,
they want to replicate it.

The behavior matches "cp -p" or "tar -x" and yes those are not
system calls but so what.  What matters is the documentation is
clear about what happens and the most useful result occurs.

jim
