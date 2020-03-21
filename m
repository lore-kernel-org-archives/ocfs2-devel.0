From: Chao Yu <chao@kernel.org>
Date: Sat, 21 Mar 2020 20:35:12 +0800
Subject: [Ocfs2-devel] [f2fs-dev] [PATCH v9 23/25] f2fs: Pass the inode
 to f2fs_mpage_readpages
In-Reply-To: <20200320142231.2402-24-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-24-willy@infradead.org>
Message-ID: <df3cc7a5-bf8b-da53-1dc6-5db185f7a4b3@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2020-3-20 22:22, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> This function now only uses the mapping argument to look up the inode,
> and both callers already have the inode, so just pass the inode instead
> of the mapping.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
