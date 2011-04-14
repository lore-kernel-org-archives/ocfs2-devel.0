From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Thu, 14 Apr 2011 14:15:31 -0700
Subject: [Ocfs2-devel] [PATCH V8 0/8] Cleancache
Message-ID: <20110414211531.GA27661@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com, dan.magenheimer@oracle.com, mel@csn.ul.ie, yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org

[PATCH V8 0/8] Cleancache

This is a courtesy repost to lkml and linux-mm.  As of 2.6.39-rc1,
Linus has said that he will review cleancache but hasn't yet, so
I am updating the patchset to the very latest bits.  The patchset
can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git
	(branch stable/cleancache-v8-with-tmem)

Version 8 of the cleancache patchset:
- Rebase to 2.6.39-rc3
- Resolve trivial merge conflicts for linux-next 
- Adapt to recent remove_from_page_cache patchset by Minchan Kim
- Fix exportfs issue that affected btrfs under certain circumstances
- Change two macros to static inlines (per akpm)
- Minor documentation changes

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
(see individual patches for additional Acks/SOBs etc)

 Documentation/ABI/testing/sysfs-kernel-mm-cleancache |   11 
 Documentation/vm/cleancache.txt                      |  278 +++++++++++++++++++
 fs/btrfs/extent_io.c                                 |    9 
 fs/btrfs/super.c                                     |    2 
 fs/buffer.c                                          |    5 
 fs/ext3/super.c                                      |    2 
 fs/ext4/super.c                                      |    2 
 fs/mpage.c                                           |    7 
 fs/ocfs2/super.c                                     |    2 
 fs/super.c                                           |    3 
 include/linux/cleancache.h                           |  122 ++++++++
 include/linux/fs.h                                   |    5 
 mm/Kconfig                                           |   23 +
 mm/Makefile                                          |    1 
 mm/cleancache.c                                      |  244 ++++++++++++++++
 mm/filemap.c                                         |   11 
 mm/truncate.c                                        |    6 
 17 files changed, 733 insertions(+)
