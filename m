From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:14 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2: Fix orphan dir handling in
	ocfs2_create_inode_in_orphan
Message-ID: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_create_inode_in_orphan() is used by reflink to create the newly
reflinked inode simultaneously in the orphan dir. This allows us to easily
handle partially-reflinked files during recovery cleanup.

We have a problem though - the orphan dir stringifies inode # to determine
a unique name under which the orphan entry dirent can be created. Since
ocfs2_create_inode_in_orphan() needs the space allocated in the orphan dir
before it can allocate the inode, we currently call into the orphan code:

       /*
        * We give the orphan dir the root blkno to fake an orphan name,
        * and allocate enough space for our insertion.
        */
       status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
                                         osb->root_blkno,
                                         orphan_name, &orphan_insert);

Using osb->root_blkno might work fine on unindexed directories, but the
orphan dir can have an index.  When it has that index, the above code fails
to allocate the proper index entry.  Later, when we try to remove the file
from the orphan dir (using the actual inode #), the reflink operation will
fail.

The following patch series fixes the problem in several stages. The first 4
patches refactor what parts of the code needed to be seperated out to allow
proper ordering of the cluster locks and allocator actions. The last patch
puts it all together in a new helper function which takes care to order
every part of the operation carefully.

View:
http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2-mark.git;a=shortlog;h=refs/heads/reflink_fixes

Pull:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2-mark.git reflink_fixes
	--Mark
