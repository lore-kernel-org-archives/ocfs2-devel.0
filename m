From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 17 Oct 2018 01:28:14 -0700
Subject: [Ocfs2-devel] [PATCH 10/26] vfs: combine the clone and dedupe
 into a single remap_file_range
In-Reply-To: <153965946503.1256.14921970220584184352.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
	<153965946503.1256.14921970220584184352.stgit@magnolia>
Message-ID: <20181017082814.GB16896@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> +/* All valid REMAP_FILE flags */
> +#define REMAP_FILE_VALID_FLAGS		(REMAP_FILE_DEDUP)

It looks like this still isn't used after the whole series.

With it removed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
