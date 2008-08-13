From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 13 Aug 2008 13:32:40 -0700
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for
	not-merging.
In-Reply-To: <1218648792-5033-1-git-send-email-tao.ma@oracle.com>
References: <20080812205225.GH21187@wotan.suse.de>
	<1218648792-5033-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20080813203240.GO21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 14, 2008 at 01:33:12AM +0800, Tao Ma wrote:
> From: taoma <taoma@tma-home.cn.oracle.com>
> 
> Hi Mark,
> 	Here is the patch we discussed this morning.
> 
> In xattr bucket, we want to limit the maximum size of a btree leaf,
> otherwise we'll lose the benefits of hashing because we'll have to search
> large leaves.
> 
> So add a new flag in ocfs2_extent_tree which will prevent ocfs2_insert_extent
> from merging the leaf record even if they are contiguous.

Ok, this is close... The problem I see here though is that we've gone from
always merging when possible to *never* merging.

What we want is "don't merge if the resulting extent is larger than a given
size".

So, instead of a flags field, how about "unsigned int max_extent_clusters".
If it's zero, we don't limit the extent. Otherwise, we honor the value it is
set to. A (cleaner) alternative would be to set it to the max value a u16 can have by
default so we never have to do an explicit "is this zero" check.


Inside of ocfs2_figure_contig_type():

... ocfs2_figure_contig_type(...) {
	...
	unsigned int len = le16_to_cpu(ext_rec->e_leaf_clusters) + le16_to_cpu(insert_rec->e_leaf_clusters);

	/*
	 * Caller might want us to limit the size of extents, don't calculate
	 * contiguousness if we might exceed that limit.
	 */
	if (et->max_extent_clusters && len > et->max_extent_clusters) {
	        insert->ins_contig = CONTIG_NONE;
	        return;
	}

	...
}

Thanks,
	--Mark

--
Mark Fasheh
