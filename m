From: jim owens <jowens@hp.com>
Date: Wed, 06 May 2009 10:30:57 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
 call.
In-Reply-To: <4A019DA9.4050700@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
Message-ID: <4A019F21.2020907@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com
Cc: Andreas Dilger <adilger@sun.com>, Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

P.S. as people have already said, both

1) "snapfile" - Joel's reflink(2) design.
2) "cowfilecopy" - Ted's/Jamie's kernel cp.

could be 1 syscall with a "preserve" flag that requires CAP_FCHOWN.
