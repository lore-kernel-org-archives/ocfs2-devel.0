From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 12 Feb 2020 20:38:52 -0800
Subject: [Ocfs2-devel] [PATCH 00/12] Change readahead API
In-Reply-To: <20200125013553.24899-1-willy@infradead.org>
References: <20200125013553.24899-1-willy@infradead.org>
Message-ID: <20200212203852.8b7e0b28974e41227bd97329@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 24 Jan 2020 17:35:41 -0800 Matthew Wilcox <willy@infradead.org> wrote:

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This series adds a readahead address_space operation to eventually
> replace the readpages operation.  The key difference is that
> pages are added to the page cache as they are allocated (and
> then looked up by the filesystem) instead of passing them on a
> list to the readpages operation and having the filesystem add
> them to the page cache.  It's a net reduction in code for each
> implementation, more efficient than walking a list, and solves
> the direct-write vs buffered-read problem reported by yu kuai at
> https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20200116063601.39201-1-yukuai3 at huawei.com/__;!!GqivPVa7Brio!NlcuIpmGG67857GpPsQFkRWjsRfX5X7n3Fb8MYpdwgIOZr-DoCgsFLZr7P7hJIPzp3_FZA$ 

Unclear which patch fixes this and how it did it?
