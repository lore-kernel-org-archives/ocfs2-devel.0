From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 16 Feb 2011 00:26:54 -0600
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <20110214222524.GD8413@noexit>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
	<AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
	<20110214220021.GB8413@noexit>
	<AANLkTikPdMgJWexFbBx8fRKxwAoKGsbiYkHR49Kfk90=@mail.gmail.com>
	<20110214222524.GD8413@noexit>
Message-ID: <AANLkTikuoTW0_LXPE93CXVy3uK1DDeghb0pKemfpii4g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 4:25 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Mon, Feb 14, 2011 at 04:16:37PM -0600, Goldwyn Rodrigues wrote:
>> Oh, I thought the test case was self-explanatory. The test case first writes
>> a lot of dirty data on disk "0xbaadfeed", syncs the data and removes
>> the file so that the filesystem has a lot of "0xbaadfeed" data on it.
>>
>> The second executable writes records of 32 bytes and seeks another 32
>> bytes. While reading the file back, 0xbaadfeed is read when zeros are
>> expected. The program shows where the unexpected data is found.
>>
>> So, for holes not spanning extents or even blocks, the data which was
>> on disk previously shows up.
>
> ? ? ? ?That shouldn't happen, of course. ?But the solution will not be
> writing past the last block of the file. ?We should be catching it
> instead when extending the i_size into a previously uninitialized block.
>

The problem occurs when the last few bytes of the previous page is a
hole, and the write starts from the beginning of next page. This
causes the page to be read in ocfs2_map_page_blocks(), and since this
is a new block, it picks up garbage from the disk. So, the best way
seems to be enforce it to be a new page when writing from block
boundary by testing against pos.

I tested this patch. However, could you check if this would affect
anything else?

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1fbb0e2..3dcca2a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1026,6 +1026,8 @@ static int ocfs2_prepare_page_for_write(struct
inode *inode, u64 *p_blkno,
        ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
                                        &cluster_start, &cluster_end);

+       new = new | (page_offset(page) == user_pos);
+
        if (page == wc->w_target_page) {
                map_from = user_pos & (PAGE_CACHE_SIZE - 1);
                map_to = map_from + user_len;





-- 
Goldwyn
