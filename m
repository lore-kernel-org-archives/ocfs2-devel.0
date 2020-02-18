From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 13:52:48 -0800
Subject: [Ocfs2-devel] [PATCH v6 01/19] mm: Return void from various
	readahead functions
In-Reply-To: <20200218212115.GG24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-2-willy@infradead.org>
	<29d2d7ca-7f2b-7eb4-78bc-f2af36c4c426@nvidia.com>
	<20200218212115.GG24185@bombadil.infradead.org>
Message-ID: <df31e4a4-fe1a-5826-c8e1-c66e5197e071@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/18/20 1:21 PM, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 01:05:29PM -0800, John Hubbard wrote:
>> This is an easy review and obviously correct, so:
>>
>>     Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> 
> Thanks
> 
>> Thoughts for the future of the API:
>>
>> I will add that I could envision another patchset that went in the
>> opposite direction, and attempted to preserve the information about
>> how many pages were successfully read ahead. And that would be nice
>> to have (at least IMHO), even all the way out to the syscall level,
>> especially for the readahead syscall.
> 
> Right, and that was where I went initially.  It turns out to be a
> non-trivial aount of work to do the book-keeping to find out how many
> pages were _attempted_, and since we don't wait for the I/O to complete,
> we don't know how many _succeeded_, and we also don't know how many
> weren't attempted because they were already there, and how many weren't
> attempted because somebody else has raced with us and is going to attempt
> them themselves, and how many weren't attempted because we just ran out
> of memory, and decided to give up.
> 
> Also, we don't know how many pages were successfully read, and then the
> system decided to evict before the program found out how many were read,
> let alone before it did any action based on that.
> 


That is even worse than I initially thought. :)


> So, given all that complexity, and the fact that nobody actually does
> anything with the limited and incorrect information we tried to provide
> today, I think it's fair to say that anybody who wants to start to do
> anything with that information can delve into all the complexity around
> "what number should we return, and what does it really mean".  In the


Yes, and now that you mention it, it's really tough to pick a single number
that answers the right questions that the user space caller might have. whew.


> meantime, let's just ditch the complexity and pretense that this number
> means anything.
> 

Definitely. Thanks for the notes here.


thanks,
-- 
John Hubbard
NVIDIA
