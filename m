From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 19 Mar 2020 04:57:01 -0700
Subject: [Ocfs2-devel] [PATCH v8 00/25] Change readahead API
In-Reply-To: <20200319102038.GE3590@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
	<20200319102038.GE3590@infradead.org>
Message-ID: <20200319115701.GJ22433@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 19, 2020 at 03:20:38AM -0700, Christoph Hellwig wrote:
> Any plans to resend this with the little nitpicks fixed?  I'd love to
> get this series into 5.7..

The only nitpick I see left is the commit comment in the btrfs patch,
and a note from Dave Sterba that he intends to review it.  I can collect
up the additional Reviewed-by tags and repost the series.

I'm assuming it'll go through Andrew's tree?
