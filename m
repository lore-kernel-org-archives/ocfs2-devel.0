From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Wed, 6 May 2009 07:57:12 +0200
Subject: [Ocfs2-devel] copyfile semantics.
In-Reply-To: <20090505214454.GP3209@webber.adilger.int>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<20090505164619.GA32180@logfs.org>
	<20090505214454.GP3209@webber.adilger.int>
Message-ID: <20090506055712.GA7562@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: Jamie Lokier <jamie@shareable.org>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, 5 May 2009 15:44:54 -0600, Andreas Dilger wrote:
> 
> > or copyfile() will also have to create a tempfile, rename the
> > tempfile when the copy is done and deal with all possible errors.  And
> > if the system crashes, who will remove the tempfile on reboot?  Will the
> > tempfile have a well-known name, allowing for easy DoS?  Or will it be
> > random, causing much fun locating it after reboot.
> 
> Maybe I'm missing something, but why do we need a tempfile at all?
> I can't imagine that people expect atomic semantics for copyfile(),
> any more than they expect atomic sematics for "cp" in the face of a
> crash.

In the case of cowlink() a tempfile is required when breaking the link.
Otherwise open() can result in the file disappearing or being truncated.
Rather unexpected.

If copyfile() doesn't try to be smart and does the actual copy when
being called, I could certainly live with half-written files.

J?rn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
