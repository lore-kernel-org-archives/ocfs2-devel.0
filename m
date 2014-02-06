From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 6 Feb 2014 15:28:39 -0800
Subject: [Ocfs2-devel] [patch 08/11] ocfs2: should call
	ocfs2_journal_access_di()	before ocfs2_delete_entry() in
	ocfs2_orphan_del()
In-Reply-To: <20140124204708.4CAEB5A4203@corp2gmr1-2.hot.corp.google.com>
References: <20140124204708.4CAEB5A4203@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140206232839.GP24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:47:07PM -0800, akpm at linux-foundation.org wrote:
> From: Younger Liu <younger.liu@huawei.com>
> Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
> 
> While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
> ocfs2_delete_entry() before ocfs2_journal_access_di().  If
> ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
> would be a inconsistency: the file is deleted from orphan dir, but orphan
> dir dinode is not updated.
> 
> So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().

I am confused by this. Re-reading the code in fs/ocfs2/dir.c,
__ocfs2_delete_entry() takes great pains to mark the buffer head as part of
the journal:

	ocfs2_journal_access_func access = ocfs2_journal_access_db;

	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
		access = ocfs2_journal_access_di;

<snip>

			status = access(handle, INODE_CACHE(dir), bh,
					OCFS2_JOURNAL_ACCESS_WRITE);


Am I missing something here?
	--Mark

--
Mark Fasheh
