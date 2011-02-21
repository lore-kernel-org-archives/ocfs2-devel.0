From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Sun, 20 Feb 2011 23:44:05 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
	across page boundaries
In-Reply-To: <20110221020856.GL17784@noexit>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
Message-ID: <AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Feb 20, 2011 at 8:08 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Sun, Feb 20, 2011 at 12:45:05PM -0600, Goldwyn Rodrigues wrote:
>> On Sun, Feb 20, 2011 at 1:09 AM, Joel Becker <jlbec@evilplan.org> wrote:
>> > ? ? ? ?Is this a new approach to your earlier patch, or an additional
>> > change?
>>
>> This is a new approach. You can scrap the previous attempt. I started
>> reading about write prepare's once you advised to look at the write
>> front.
>
> ? ? ? ?Ok, cool. ?It definitely is along the track I was suggesting.
>
>> >> ---
>> >> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> >> index 1fbb0e2..4be220d 100644
>> >> --- a/fs/ocfs2/aops.c
>> >> +++ b/fs/ocfs2/aops.c
>> >> @@ -1026,6 +1026,12 @@ static int ocfs2_prepare_page_for_write(struct
>> >> inode *inode, u64 *p_blkno,
>> >> ? ? ? ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
>> >> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? &cluster_start, &cluster_end);
>> >>
>> >> + ? ? /* treat the write as new if the a hole/lseek spanned across
>> >> + ? ? ?* the page boundary.
>> >> + ? ? ?*/
>> >> + ? ? new = new | ((i_size_read(inode) <= page_offset(page)) &&
>> >> + ? ? ? ? ? ? ? ? ? ? (page_offset(page) <= user_pos));
>> >
>> > ? ? ? ?There are two problems here. ?First, It's not safe to claim
>> > existing data is 'new'. ?Imagine you have a 4K page and a 512B
>> > blocksize. ?The first 2 blocks of the page have data in them, but your
>> > code change will cause them to be set_uptodate() even if we haven't read
>> > them in yet.
>>
>> I did not understand this. Could you explain this in terms of
>> blocksize=512, page_offset, i_size and pos?
>> However I'll try to interpret: Won't the i_size be 1024 (assuming it
>> is the start of file) and the new flag set to false?
>
> ? ? ? ?What if i_size is 1000? ?The second block will have data,

Still false, because page_offset is zero.

> including zeros to the end of the block. ?I have to think about this
> some more to be sure where the offsets lie -- this is hard code to think
> about -- but essentially there is a difference between blocks we have
> allocated but not used yet, and blocks that are part of a brand new
> allocation. ?We need to make sure we're not confusing the two.
>

Sure, take your time. It would be nice to have an explanation.

>> > ? ? ? ?Secondly, ocfs2_should_read_blk() already checks for blocks past
>> > i_size and skips reading them. ?So if you are trying to avoid reading
>> > them, it is already handled.
>>
>> If the previous call was lseek, i_size is not updated.
>> ocfs2_should_read_blk returns true and junk read.
>
> ? ? ? ?Why would it return true if the f_pos is > i_size? ?It should
> return 0.
>

Sorry, I was wrong in my previous explanation on why
ocfs2_should_read_blk returns 1. ocfs2_should_read_blk returns 1
because of ocfs2_sparse_alloc() and hence forces the garbage read.

On a different note, what I have not been able to explain as yet is,
when the file is created on a nosparse filesystem, the holes have junk
(not 0xbaadfeed, ie what was written previously but junk). Could you
think of a reason why? In any case, this patch resolves this issue.

-- 
Goldwyn
