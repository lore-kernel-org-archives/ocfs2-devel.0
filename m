From: Jonathan Corbet <corbet@lwn.net>
Date: Tue, 19 May 2009 13:20:57 -0600
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090515205335.GB25787@mail.oracle.com>
References: <4A039FF8.7090807@hp.com> <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
Message-ID: <20090519132057.419b9de0@bike.lwn.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One tiny little thing that crossed my mind as I was looking at this...

> - REFLINK_ATTR_NONE is 0 and REFLINK_ATTR_ALL is ~0.

That, I think, could lead to unexpected results if different flags
(perhaps controlling different aspects of behavior altogether) are
added in the future.  Might it make more sense for REFLINK_ATTR_ALL to
be something like 0xffff, with the current implementation insisting
that all other bits are zero?  That would leave room for expansion of
the set of things covered by the "preserve all" semantics while,
simultaneously, allowing the addition of different types of flags
entirely.

jon
