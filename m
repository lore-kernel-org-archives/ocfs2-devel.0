From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 07 Sep 2011 10:10:43 -0700
Subject: [Ocfs2-devel] block64 failure
Message-ID: <4E67A593.70302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

All,

So the patches added to allow mounting volumes > 16TB has a problem.
The feature check of the jbd2 superblock is being done before the
jbd2 superblock is actually read.

It is being done after the journal_init_inode() which is incorrect.

ocfs2_check_volume()
   ocfs2_journal_init()
        jbd2_journal_init_inode()
   ocfs2_journal_addressable() <=== check
...

Currently the journal sb is first read during load_journal. Too late for us.
And journal_get_superblock() is not exported.

One solution is to call jbd2_journal_update_format() after jbd2_journal_init_inode().
This function is used by extX to update the journal format from V1 to V2. In our
case, we are always V2 so will be a null op. But will force read the journal sb.

Icky... hence my post.

The other option is exporting journal_get_superblock() to load the journal sb.

Suggestions?

Sunil
