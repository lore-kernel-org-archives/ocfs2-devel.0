From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Sun, 27 Jun 2010 12:02:21 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
	<20100624001437.GF20090@mail.oracle.com>
	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
	<20100624005537.GG20090@mail.oracle.com>
	<AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>
	<AANLkTilw7xckG9rpMf9M5NVMNi-PXEw4AXqskPRAVYh0@mail.gmail.com>
	<AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>
Message-ID: <AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OK, this whole approach has a problem.

I do not think the journal flag I need to check
(JBD2_FEATURE_INCOMPAT_64BIT) is even read from disk until
jbd2_journal_load() is called.

Right now, jbd2_journal_load() is called by ocfs2_journal_load(),
which not only loads the journal, but also replays it.

I can move my check until after ocfs2_journal_load() is called, but
that seems a little late...  What if the journal is dirty and the disk
is mounted on a 32-bit system?

I am inclined to move the call to jbd2_journal_load() earlier,
specifically to ocfs2_journal_init().  Once the journal structure is
initialized from the journal's inode on disk, I can check the flags to
make sure the entire volume is addressable by the journal.

Thoughts?

 - Pat
