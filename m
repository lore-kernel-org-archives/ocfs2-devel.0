From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 17 Dec 2014 15:55:57 -0800
Subject: [Ocfs2-devel] [patch 08/15] ocfs2: eliminate the static flag of
	some	functions
In-Reply-To: <548f65df.99jg2vRGqW8xchpC%akpm@linux-foundation.org>
References: <548f65df.99jg2vRGqW8xchpC%akpm@linux-foundation.org>
Message-ID: <20141217235557.GT7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:11PM -0800, Andrew Morton wrote:
> From: Weiwei Wang <wangww631@huawei.com>
> Subject: ocfs2: eliminate the static flag of some functions
> 
> Currently in case of append O_DIRECT write (block not allocated yet),
> ocfs2 will fall back to buffered I/O.  This has some disadvantages. 
> Firstly, it is not the behavior as expected.
> 
> Secondly, it will consume huge page cache, e.g.  in mass backup scenario. 
> Thirdly, modern filesystems such as ext4 support this feature.
> 
> In this patch set, the direct I/O write doesn't fallback to buffer I/O
> write any more because the allocate blocks are enabled in direct I/O now.

Thanks for taking this task on Weiwei - it's not an easy one!

I have one comment right off the bat - since we're changing how things work
on disk (in particular, the orphan handling), we'll have to gate this on a
feature flag. Otherwise, we risk corrupting if an older FS loads the newer
format. I would suggest adding a readonly feature flag and moving as much of
the fallback code into it's own set of functions to be used when the flag is
not set.
	--Mark

--
Mark Fasheh
