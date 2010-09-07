From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Sep 2010 14:18:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add missing
	ocfs2_journal_acces_*() for couple of funcs in dir.c
In-Reply-To: <1282877169-4921-1-git-send-email-tristan.ye@oracle.com>
References: <1282877169-4921-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100907211823.GD4364@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 27, 2010 at 10:46:09AM +0800, Tristan Ye wrote:
> To correctly journal the metadata in ocfs2, it's known for us to call
> ocfs2_journal_access_*() and ocfs2_journal_dirty()to mark buffer dirty,
> they are expected to exist in a pair.
> 
> Whereas several funcs for dx-dirs manipulation were forgeting to call
> appropriate ocfs2_journal_access*() to correctly journal the dirty
> metadata, which may cause a BUG in jbd2, reporting a NULL pointer
> gets ASSERTED in the journal buffer head.
> 
> Currently, we found three functions being hurt in dir.c, all serving
> for dx-dirs:
> 
>     - ocfs2_dx_dir_transfer_leaf()

NAK, this doesn't look to have a problem. Both clusters (new and old) are
journal_accessed previously. Look at ocfs2_dx_dir_rebalance and ocfs2_dx_dir_format_cluster.



>     - ocfs2_remove_block_from_free_list()
>     - ocfs2_recalc_free_list()

Can you show me the stack traces for these please? It kinda looks like you
just added journal_access calls randomly to make sure we cover everything.
Not only does that confuse the code (look at how many functions turned from
returning void to int) but it's redunant in most of the cases.
	--Mark

--
Mark Fasheh
