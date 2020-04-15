From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Date: Wed, 15 Apr 2020 09:17:24 +0000
Subject: [Ocfs2-devel] [PATCH v11 03/25] mm: Ignore return value of
	->readpages
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-4-willy@infradead.org>
Message-ID: <SN4PR0401MB35985342EC4B346DCF6E47129BDB0@SN4PR0401MB3598.namprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, John Hubbard <jhubbard@nvidia.com>, William Kucharski <william.kucharski@oracle.com>

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
