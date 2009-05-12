From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 20:20:53 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A01CDD0.6090102@hp.com>
References: <20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
	<4A019F21.2020907@hp.com> <4A01CDD0.6090102@hp.com>
Message-ID: <20090512192053.GB10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com, Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

jim owens wrote:
> Quota accounting and disk space used for the original file will
> be as if there were 0 reflinks.  Quota accounting and disk space
> reported for the new reflink file is filesystem specific and may
> or may not include shared disk space.

One little thing:

If the original file is deleted,

   1. The data must still be accounted at least once.

   2. After deleting the original, the space must not be charged to
      the owner of the original file if different from the owners of
      reflinks which remain, because that would be a quota attack.

Less important:

   3. The combination of 1 and 2 probably shouldn't cause the quota
      charge of other users (who created reflinks and aren't the
      original file owner) to increase as it might push them over their
      quota, in a way that's difficult for them to know beforehand.

One way to satisfy that is for the reflink's data to be charged at
least once to each distinct owner who references that data.  Maybe it
can be done by charging it when the owner of a new reflink is
different from the original, and something appropriate during chown.

-- Jamie
