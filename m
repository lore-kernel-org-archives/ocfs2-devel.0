From: Gao Xiang <hsiangkao@aol.com>
Date: Tue, 21 Apr 2020 15:28:51 +0800
Subject: [Ocfs2-devel] [PATCH v11 19/25] erofs: Convert compressed files
 from readpages to readahead
In-Reply-To: <20200420224210.dff005bc62957a4d81d58226@linux-foundation.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-20-willy@infradead.org>
	<20200420224210.dff005bc62957a4d81d58226@linux-foundation.org>
Message-ID: <20200421072839.GA13867@hsiangkao-HP-ZHAN-66-Pro-G1>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, William Kucharski <william.kucharski@oracle.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

Hi Andrew,

On Mon, Apr 20, 2020 at 10:42:10PM -0700, Andrew Morton wrote:
> On Tue, 14 Apr 2020 08:02:27 -0700 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > 
> > Use the new readahead operation in erofs.
> > 
> 
> Well this is exciting.
> 
> fs/erofs/data.c: In function erofs_raw_access_readahead:
> fs/erofs/data.c:149:18: warning: last_block may be used uninitialized in this function [-Wmaybe-uninitialized]
> 	*last_block + 1 != current_block) {
> 
> It seems to be a preexisting bug, which your patch prompted gcc-7.2.0
> to notice.
> 
> erofs_read_raw_page() goes in and uses *last_block, but neither of its
> callers has initialized it.  Could the erofs maintainers please take a
> look?

simply because last_block doesn't need to be initialized at first,
because bio == NULL in the begining anyway. I believe this is a gcc
false warning because some gcc versions raised some before (many gccs
don't, including my current gcc (Debian 8.3.0-6) 8.3.0).

in detail,

146         /* note that for readpage case, bio also equals to NULL */
147         if (bio &&
148             /* not continuous */
149             *last_block + 1 != current_block) {
150 submit_bio_retry:
151                 submit_bio(bio);
152                 bio = NULL;
153         }

bio will be NULL and will bypass the next condition at first.
after that,

155         if (!bio) {

...

221                 bio = bio_alloc(GFP_NOIO, nblocks);

...

}

...

230         err = bio_add_page(bio, page, PAGE_SIZE, 0);
231         /* out of the extent or bio is full */
232         if (err < PAGE_SIZE)
233                 goto submit_bio_retry;
234
235         *last_block = current_block;

so bio != NULL, and last_block will be assigned then as well.

Thanks,
Gao Xiang
