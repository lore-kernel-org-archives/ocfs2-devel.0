From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Mon,  5 Oct 2020 21:48:37 -0300
Subject: [Ocfs2-devel] [PATCH v5 0/4] ext4/jbd2: data=journal: write-protect
	pages on transaction commit
Message-ID: <20201006004841.600488-1-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

Hey Jan, Andreas, Ted et al.

This series fixes the issue that buffers writeably mapped to userspace
can be modified during transaction commit, in between checksumming and
write-out to the journal, thus cause inconsistency in the journal that
prevents recovery/mount after kernel crash or power loss.

It's really ideas and patience from Jan guiding me how to write/fix it.
Huge thanks!

Although the synthetic test case in [v2] demonstrates the bug and that
the fix works, there's stress-ng tests that still causes inconsistency.

Unfortunately I couldn't look more into it yet; per discussion in [v4]
cover letter I'll send it as-is now, since it already fixes something,
and will continue to analyze. It might be something else/another fix.

There's also some fstests that _apparently_ become more flaky w/ the
patchset applied, but don't seem to be mmap() related.. so I'll look
at them more carefully too. The set of consistent failures (ie, that
happen most of the time) is the same between original/patched builds,
on both data=ordered and data=journal (different for each mode, ofc.)

    data=ordered:
    Failures: ext4/045 generic/044 generic/045 generic/046 generic/051
generic/223 generic/388 generic/465 generic/475 generic/553
generic/554 generic/555 generic/565 generic/611

    data=journal:
    Failures: ext4/045 generic/051 generic/223 generic/347 generic/388
generic/441 generic/475 generic/553 generic/554 generic/555
generic/565 generic/611

There's a small change to OCFS2 in patch 2, which has been tested w/
stress-ng's filesystem and io stressor classes; no regressions found.

    # mkfs.ocfs2 --mount local $DEV
    # mount $DEV $MNT
    # cd $MNT
    # stress-ng --sequential 0 --class filesystem,io

The only changes from v4 are style-change suggestions from Andreas
applied to patches 02/04 and where we set OCFS2 journal callbacks;
plus Reviewed-By: tags.

Tested on v5.9-rc7'ish and next-20200930; build tested on -rc8'ish
and next-20201002 today.

cheers,
Mauricio

[v4] https://urldefense.com/v3/__https://lore.kernel.org/linux-ext4/20200928194103.244692-1-mfo at canonical.com/__;!!GqivPVa7Brio!KLi18zziDAgi-C8ol7nWzoPGTJ3JSrOijN1MmSjdZ3Zw9wnZNnCNYgoJq7LjaeoH9QUyCg$ 
[v3] https://urldefense.com/v3/__https://lore.kernel.org/linux-ext4/20200910193127.276214-1-mfo at canonical.com/__;!!GqivPVa7Brio!KLi18zziDAgi-C8ol7nWzoPGTJ3JSrOijN1MmSjdZ3Zw9wnZNnCNYgoJq7LjaeodPYbH2w$ 
[v2] https://urldefense.com/v3/__https://lore.kernel.org/linux-ext4/20200810010210.3305322-1-mfo at canonical.com/__;!!GqivPVa7Brio!KLi18zziDAgi-C8ol7nWzoPGTJ3JSrOijN1MmSjdZ3Zw9wnZNnCNYgoJq7LjaeocoAghAA$ 
[v1] https://urldefense.com/v3/__https://lore.kernel.org/linux-ext4/20200423233705.5878-1-mfo at canonical.com/__;!!GqivPVa7Brio!KLi18zziDAgi-C8ol7nWzoPGTJ3JSrOijN1MmSjdZ3Zw9wnZNnCNYgoJq7LjaepKEikFzg$ 

Mauricio Faria de Oliveira (4):
  jbd2: introduce/export functions
    jbd2_journal_submit|finish_inode_data_buffers()
  jbd2, ext4, ocfs2: introduce/use journal callbacks
    j_submit|finish_inode_data_buffers()
  ext4: data=journal: fixes for ext4_page_mkwrite()
  ext4: data=journal: write-protect pages on
    j_submit_inode_data_buffers()

 fs/ext4/inode.c      | 62 ++++++++++++++++++++++++++-----
 fs/ext4/super.c      | 87 ++++++++++++++++++++++++++++++++++++++++++++
 fs/jbd2/commit.c     | 62 ++++++++++++++++---------------
 fs/jbd2/journal.c    |  2 +
 fs/ocfs2/journal.c   |  4 ++
 include/linux/jbd2.h | 29 ++++++++++++++-
 6 files changed, 206 insertions(+), 40 deletions(-)

-- 
2.17.1
