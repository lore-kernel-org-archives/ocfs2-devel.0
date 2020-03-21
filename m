From: Chao Yu <chao@kernel.org>
Date: Sat, 21 Mar 2020 20:34:23 +0800
Subject: [Ocfs2-devel] [f2fs-dev] [PATCH v9 22/25] f2fs: Convert from
 readpages to readahead
In-Reply-To: <20200320142231.2402-23-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-23-willy@infradead.org>
Message-ID: <557257d3-6799-df31-378a-a39c36fa3191@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2020-3-20 22:22, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Use the new readahead operation in f2fs
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
