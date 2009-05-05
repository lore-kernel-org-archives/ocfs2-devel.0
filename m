From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Tue, 5 May 2009 18:54:33 +0200
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505164619.GA32180@logfs.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<20090505164619.GA32180@logfs.org>
Message-ID: <20090505165433.GB32180@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, 5 May 2009 18:46:19 +0200, J?rn Engel wrote:
> 
> And depending on the fs design, the read/write loop can be
> replaced with finer-grained reference counting.

And maybe finer-grained reference counting should be a requirement for
copyfile/cowlink/reflink or whatever we call it.  With a large file on
slow media, open("foo", O_RDWR); should still return in a reasonable
amount of time.  Not after ten minutes.

J?rn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
