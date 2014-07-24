From: David Sterba <dsterba@suse.cz>
Date: Thu, 24 Jul 2014 21:22:45 +0200
Subject: [Ocfs2-devel] [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED
	flag
In-Reply-To: <B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
	<B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
Message-ID: <20140724192245.GG1553@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, Btrfs Developer List <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Thu, Jul 17, 2014 at 12:07:57AM -0600, Andreas Dilger wrote:
> any progress on this patch series?

I'm sorry I got distracted at the end of year and did not finish the
series.

> I never saw an updated version of this patch series after the last round of
> reviews, but it would be great to move it forward.  I have filefrag patches
> in my e2fsprogs tree waiting for an updated version of your patch.
> 
> I recall the main changes were:
> - add FIEMAP_EXTENT_PHYS_LENGTH flag to indicate if fe_phys_length was valid

fe_phys_length will be always valid, so other the flags are set only if it's
not equal to the logical length.

> - rename fe_length to fe_logi_length and #define fe_length fe_logi_length
> - always fill in fe_phys_length (= fe_logi_length for uncompressed files)
>   and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed or not

This is my understanding and contradicts the first point.

> - add WARN_ONCE() in fiemap_fill_next_extent() as described below
>
> I don't know if there was any clear statement about whether there should be
> separate FIEMAP_EXTENT_PHYS_LENGTH and FIEMAP_EXTENT_DATA_COMPRESSED flags,
> or if the latter should be implicit?  Probably makes sense to have separate
> flags.  It should be fine to use:
>
> #define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010
> 
> since this flag was never used.

I've kept only FIEMAP_EXTENT_DATA_COMPRESSED, I don't see a need for
FIEMAP_EXTENT_PHYS_LENGTH and this would be yet another flag because the
FIEMAP_EXTENT_DATA_ENCODED is also implied.

I'll send V4, we can discuss the PHYS_LENGTH flag then.
