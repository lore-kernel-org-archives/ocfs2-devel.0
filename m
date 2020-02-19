From: John Hubbard <jhubbard@nvidia.com>
Date: Wed, 19 Feb 2020 12:24:26 -0800
Subject: [Ocfs2-devel] [PATCH v6 07/19] mm: Put readahead pages in cache
	earlier
In-Reply-To: <20200219150103.GQ24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-12-willy@infradead.org>
	<e3671faa-dfb3-ceba-3120-a445b2982a95@nvidia.com>
	<20200219144117.GP24185@bombadil.infradead.org>
	<20200219145246.GA29869@infradead.org>
	<20200219150103.GQ24185@bombadil.infradead.org>
Message-ID: <a5f8ba4c-8413-2633-9523-5b5941c0762b@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/19/20 7:01 AM, Matthew Wilcox wrote:
> On Wed, Feb 19, 2020 at 06:52:46AM -0800, Christoph Hellwig wrote:
>> On Wed, Feb 19, 2020 at 06:41:17AM -0800, Matthew Wilcox wrote:
>>> #define readahead_for_each(rac, page)                                   \
>>>         while ((page = readahead_page(rac)))
>>>
>>> No more readahead_next() to forget to add to filesystems which don't use
>>> the readahead_for_each() iterator.  Ahem.


Yes, this looks very clean. And less error-prone, which I definitely
appreciate too. :)


>>
>> And then kill readahead_for_each and open code the above to make it
>> even more obvious?
> 
> Makes sense.
> 

Great!


thanks,
-- 
John Hubbard
NVIDIA
