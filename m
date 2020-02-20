From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Date: Thu, 20 Feb 2020 09:42:19 +0000
Subject: [Ocfs2-devel] [PATCH v7 14/24] btrfs: Convert from readpages to
	readahead
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-15-willy@infradead.org>
Message-ID: <SN4PR0401MB35987D7B76007B93B1C5CE5E9B130@SN4PR0401MB3598.namprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 19/02/2020 22:03, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in btrfs.  Add a
> readahead_for_each_batch() iterator to optimise the loop in the XArray.


OK I must admit I haven't followed this series closely, but what 
happened to said readahead_for_each_batch()?

As far as I can see it's now:

[...]
> +	while ((nr = readahead_page_batch(rac, pagepool))) {
