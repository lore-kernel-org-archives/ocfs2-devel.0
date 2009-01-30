From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 30 Jan 2009 13:42:26 -0800
Subject: [Ocfs2-devel] [PATCH 0/7] ocfs2: Directory indexing support
Message-ID: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches implement indexed directory support in Ocfs2, mostly
according to the design doc I wrote up a while ago:

http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedDirectories

The patches have been rebased on top of 2.6.29-rc2. It should be trivial to
put them into merge_window. Things are what I'd call complete now. I'd like
to get these into the merge_window branch sooner rather than later, so any
reviews are appreciated :)

Changes from last time:

- Added inline indexing support. This turned out to be a good idea - many
  directories just keep their index inlined.

- Rebased so it fully complies with metaecc and quota requirements.

- Lots of bugs fixed.


There's a 'dx_dirs' branch in ocfs2.git:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git dx_dirs


I've tested this batch of patches with kernel builds, and various bash loops
to create large numbers of files. Last time around, it survived a two day
exorcist run. I'll schedule another one for the weekend.


Tools support for this is available in ocfs2-tools.git:

git pull git://oss.oracle.com/git/ocfs2-tools.git dx_dirs

I won't post the exact tools patches just yet. There's enough support in
there that we can mkfs, tunefs (only turning the feature on) and debugfs. I
need to add better write support and of course things like fsck, etc. The
good news is tha the debugfs.ocfs2 support is what I'd call complete - it
should allow us to fully debug and visualize the on-disk structures in
question.
	--Mark

--
Mark Fasheh
