From: Chao Yu <chao@kernel.org>
Date: Sat, 21 Mar 2020 20:38:19 +0800
Subject: [Ocfs2-devel] [f2fs-dev] [PATCH v9 18/25] erofs: Convert
 uncompressed files from readpages to readahead
In-Reply-To: <20200320142231.2402-19-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-19-willy@infradead.org>
Message-ID: <2796a575-dd89-6cfb-a7af-511a2f463fda@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2020-3-20 22:22, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Use the new readahead operation in erofs
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Gao Xiang <gaoxiang25@huawei.com>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>
