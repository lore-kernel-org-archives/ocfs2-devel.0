From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 18 Jan 2012 12:00:15 -0600
Subject: [Ocfs2-devel] Question about incorrect free bits setting
Message-ID: <CAJtY7HWnYqX=CeU+G7YRGRwrANaZ5itRiu13J+HkLA+zQ6FmCQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have a customer who was running into read-only filesystem because
of incorrect free bits set/calculation. We have provided the fix from
here, which avoids the read-only problem
http://oss.oracle.com/pipermail/ocfs2-devel/2011-November/008431.html

Though the filesystem is does not turn read-only, we still get messages like -

[ 5017.452846] (ocfs2_wq,8480,0):ocfs2_block_group_clear_bits:2113
ERROR: Trying to clear 1 bits at offset 7658 in group descriptor #
7644672 (device cciss/c0d0p3), needed to clear 0 bits

We are investigating how the bits get free in the first place because
another allocation could claim the bits marked as free.

The question is:

Why does ocfs2_release_clusters has ocfs2_clear_bit as the undo
function wheras ocfs2_free_clusters has ocfs2_set_bit as the undo
function? Should it be NULL for ocfs2_release_clusters?

-- 
Goldwyn
